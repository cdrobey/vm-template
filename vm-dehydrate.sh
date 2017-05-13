#!/bin/bash

#  File: vm-dehydrate.sh
#
#  Use: Cleanse a base Ubuntu Server Image
#
#  Description: Performs a removal of all system files and forces an ssh
#  key update during initial boot. Storage scripts in /etc/vm-template
#
#  Command: /etc/vm-template/vm-dehydrate
#
# -*- mode: ruby -*-
# vi: set ft=ruby 
#

# Update and Upgrade  Apt Repository
apt-get update
apt-get -y upgrade

# Add basic packages for Template
apt-get -y install open-vm-tools openssh-server aptitude 

echo "Removing openssh-server's host keys..."
rm -vf /etc/ssh/ssh_host_*
cat /dev/null > /etc/rc.local

cat << EOF >> /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

if [ -x /etc/vm-template/vm-template.sh ]
then
	/etc/vm-template/vm-template.sh
	chmod -x /etc/vm-template/vm-template.sh
fi

exit 0
EOF


echo "Cleaning up /var/mail..."
rm -vf /var/mail/*

echo "Clean up apt cache..."
find /var/cache/apt/archives -type f -exec rm -vf \{\} \;

echo "Clean up ntp..."
rm -vf /var/lib/ntp/ntp.drift
rm -vf /var/lib/ntp/ntp.conf.dhcp

echo "Clean up dhcp leases..."
rm -vf /var/lib/dhcp/*.leases*
rm -vf /var/lib/dhcp3/*.leases*

echo "Clean up udev rules..."
rm -vf /etc/udev/rules.d/70-persistent-cd.rules 
rm -vf /etc/udev/rules.d/70-persistent-net.rules

echo "Clean up urandom seed..."
rm -vf /var/lib/urandom/random-seed

echo "Clean up backups..."
rm -vrf /var/backups/*;
rm -vf /etc/shadow- /etc/passwd- /etc/group- /etc/gshadow- /etc/subgid- /etc/subuid-

echo "Cleaning up /var/log..."
find /var/log -type f -name "*.gz" -exec rm -vf \{\} \;
find /var/log -type f -name "*.1" -exec rm -vf \{\} \;
find /var/log -type f -exec truncate -s0 \{\} \;

echo "Cleaning up /var/log... and /mmp"
rm -rf /tmp/*
rm -rf /var/tmp/*

echo "Reset Hostname"
cat /dev/null > /etc/hostname
	
echo "Clearing bash history..."
cat /dev/null > /root/.bash_history
history -c
history -w

echo "Cleaning Apt"
apt-get clean

echo "Process complete..."
## poweroff
