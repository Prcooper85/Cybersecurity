## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

(Images/cloud_architecture.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook files may be used to install only certain pieces of it, such as Filebeat.

(https://github.com/Prcooper85/Cybersecurity/blob/main/Images/install_elk.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- What aspect of security do load balancers protect? Load balancers help protect against DDoS attacks in addition to the Web Application Firewall providing defence from threat actors.
- What is the advantage of a jump box? The use of a jump box provides a highly secured gateway to your internal network vastly reducing the networks attack surface. Configured correctly with connections allowed only from a singular trusted source allows you to perform administrative duties to the network with minimal risk of being exploited by a threat actor.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the filesystem and system configuration/metrics.
- What does Filebeat watch for? Log files from numerous services/modules as well as those generated by the system and forwards them to elasticsearch for indexing and provides a simple way to view and interpret all of their information.
- What does Metricbeat record? Real time system and service metrics

The configuration details of each machine may be found below.

| Name     | Function  | IP Address                      | Operating System |
|----------|-----------|---------------------------------|------------------|
| Jump Box | Gateway   | 52.250.54.228 Pub 10.0.0.7 Priv | Ubuntu Linux     |
| Web1     | DVWA Host | 10.0.0.8 Priv                   | Ubuntu Linux     |
| Web2     | DVWA Host | 10.0.0.9 Priv                   | Ubuntu Linux     |
| ElkVM    | ELK Host  | 20.38.173.131 Pub 10.1.0.4 Priv | Ubuntu Linux     |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

- 218.215.86.230

Machines within the network can only be accessed by 10.0.0.7.
- Which machine did you allow to access your ELK VM? Jump Box Provisioner: 10.0.0.7

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes                 | <Current Local IP>   |
| Web1     | No                  | 10.0.0.7             |
| Web2     | No                  | 10.0.0.7             |
| ElkVM    | No                  | 10.0.0.7             |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- What is the main advantage of automating configuration with Ansible? Ansible through the use of playbooks can automate complex tasks repeatedly whilst being less vulnerable to error.
These tasks are easily scalable to quickly and efficiently configure newly deployed systems.

The playbook implements the following tasks:

- Set vm.max_map_count to 262144 in sysctl
- Install Docker
- Install pip3
- PIP install Docker
- Pull Docker container elk:761 and publish ports 5601:5601,9200:9200,5044:5044
-Enable Docker service at startup




The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

(https://github.com/Prcooper85/Cybersecurity/blob/main/Images/docker_ps_output.png)

### Target Machines & Beats

This ELK server is configured to monitor the following machines:

- 10.0.0.8
- 10.0.0.9

We have installed the following Beats on these machines:
- Filebeats
- Metricbeats

These Beats allow us to collect the following information from each machine:
- Filebeat collects log information about the filesystem including which files have changed and when. We will see logs being generated by the DVWA Apache server and MySQL database.
- Metricbeat collects machine metrics. We will see things such as uptime and memory usage etc.

### Using the Playbook

In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the configuration file to /etc/ansible/files
- Update the hosts file to include the IP address of the machines to run the playbook on defined by groups ie [elk] or [webserver]
- Run the playbook, and navigate to 20.38.173.131:5601 to check that the installation worked as expected.

- Which file is the playbook? Where do you copy it? 
install_filebeat.yml
install_metricbeat.yml

/etc/ansible/roles

- Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?

/etc/ansible/hosts

[elk]

'elk machine ip' ansible_python_interpreter=/usr/bin/python3

[webservers]

'webserver ip' ansible_python_interpreter=/usr/bin/python3

- Which URL do you navigate to in order to check that the ELK server is running?

'Elk machine ip':5601/app/kibana

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

curl https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/files/filebeat-config.yml

cd /etc/ansible/files
nano filebeat-config.yml

edit line #1106

output.elasticsearch:
hosts: ["10.1.0.4:9200"]
username: "elastic"
password: "changeme"

edit line #1806

setup.kibana:
host: "10.1.0.4:5601"


cd /etc/ansible/roles
nano install_filebeat.yml

---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb

  - name: install filebeat deb
    command: sudo dpkg -i filebeat-7.6.1-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes

ansible-playbook install_filebeat.yml

navigate to 'elkvm public ip':5601/app/kibana#/home/tutorial/systemlogs

go to step five and click check data on the right to see if receiving filebeat data

(https://github.com/Prcooper85/Cybersecurity/blob/main/Images/filebeat_data.png)

---------------------------------------------

For metricbeat use the following commands.

cd /etc/ansible/files
curl https://gist.githubusercontent.com/slape/58541585cc1886d2e26cd8be557ce04c/raw/0ce2c7e744c54513616966affb5e9d96f5e12f73/metricbeat > /etc/ansible/files/metricbeat_config.yml

nano metricbeat_config.yml

go to line #61

setup.kibana:
  host: "10.1.0.4:5601"

go to line #95

  hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme"


cd /etc/ansible/roles

nano install_metricbeat.yml

---
- name: installing and launching metricbeat
  hosts: webservers
  become: yes
  tasks:

  - name: download metricbeat deb
    command: sudo curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

  - name: install metricbeat deb
    command: sudo dpkg -i metricbeat-7.6.1-amd64.deb

  - name: drop in metricbeat.yml
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: enable and configure system module
    command: sudo metricbeat modules enable docker

  - name: setup metricbeat
    command: sudo metricbeat setup

  - name: start metricbeat service
    command: sudo service metricbeat start

  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes

ansible-playbook install_metricbeat.yml

navigate to 'elkvm public ip':5601/app/kibana#/home/tutorial/dockerMetrics

go to step five and press check data button on right to see you are receiving metric data.

(https://github.com/Prcooper85/Cybersecurity/blob/main/Images/metricbeat_data.png)

