#!/bin/bash

#  File: vm-dehydrate-ubuntu.sh
#
#  Use: Cleanse a base Ubuntu Server Image
#
#  Description: Performs a removal of all system files and forces an ssh
#  key update during initial boot. Storage scripts in /etc/vm-template
#
#  Command: /etc/vm-template/vm-dehydrate-ubuntu.sh
#

# Update and Upgrade  Apt Repository
apt-get update
apt-get -y upgrade

# Add basic packages for Template
apt-get -y install open-vm-tools openssh-server aptitude 

# "Removing openssh-server's host keys..."
rm -vf /etc/ssh/ssh_host_*

# "Cleaning up /var/mail..."
rm -vf /var/mail/*

# "Clean up apt cache..."
find /var/cache/apt/archives -type f -exec rm -vf \{\} \;

# "Clean up ntp..."
rm -vf /var/lib/ntp/ntp.drift
rm -vf /var/lib/ntp/ntp.conf.dhcp

# "Clean up dhcp leases..."
rm -vf /var/lib/dhcp/*.leases*
rm -vf /var/lib/dhcp3/*.leases*

# "Clean up udev rules..."
rm -vf /etc/udev/rules.d/70-persistent-cd.rules 
rm -vf /etc/udev/rules.d/70-persistent-net.rules

# "Clean up urandom seed..."
rm -vf /var/lib/urandom/random-seed

# "Clean up backups..."
rm -vrf /var/backups/*;
rm -vf /etc/shadow- /etc/passwd- /etc/group- /etc/gshadow- /etc/subgid- /etc/subuid-

# "Cleaning up /var/log..."
find /var/log -type f -name "*.gz" -exec rm -vf \{\} \;
find /var/log -type f -name "*.1" -exec rm -vf \{\} \;
find /var/log -type f -exec truncate -s0 \{\} \;

# "Cleaning up /var/log... and /mmp"
rm -rf /tmp/*
rm -rf /var/tmp/*

# "Reset Hostname"
cat /dev/null > /etc/hostname
	
# "Clearing bash history..."
cat /dev/null > /root/.bash_history
history -c
history -w

# "Cleaning Apt"
apt-get clean

# "Process complete..."
poweroff
