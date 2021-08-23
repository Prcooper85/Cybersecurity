#!/bin/bash
apt-get update -y
apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove --purge -y

apt-get update -y && apt-get upgrade -y && apt-get check -y && apt-get autoremove --purge -y &&
