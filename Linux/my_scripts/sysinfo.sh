#!/bin/bash

echo -e "This is my first bash script"  > ~/research/sys_info.txt
echo -e "Todays date is $(date)"  >> ~/research/sys_info.txt
echo -e "The machines name is $(uname)"  >> ~/research/sys_info.txt
echo -e "The machines I.P. Address is $(ip address | grep 127.0.0.1 | awk '{print $2}')\n" >> ~/research/sys_info.txt
echo -e "The hostname is $HOSTNAME" >> ~/research/sys_info.txt
echo -e "\nMy DNS is $(cat /etc/resolv.conf | grep 8.8.8.8 | awk '{print $2}')" >> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
echo -e "\nThe systems memory info is " >> ~/research/sys_info.txt
free  >> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
echo -e "\nThe cpuinfo is $(cat /proc/cpuinfo | head)/n" >> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
echo -e "\nThe disk info is" >> ~/research/sys_info.txt
df -H | head -2  >> ~/research/sys_info.txt 

find -perm 777 >> ~/research/sys_info.txt
ps aux | head >> ~/research/sys_info.txt

