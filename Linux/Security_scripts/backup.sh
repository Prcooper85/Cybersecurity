#!/bin.bash
sudo tar cvf /var/backup/home.tar /home/
sudo mv /var/backup/home.tar /var/backup/home.$DATE.tar
ls -lah /var/backup >> /var/backup/file_report.txt 
free -h >> /var/backup/disk_report.txt

