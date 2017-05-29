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

# some variables
export ADMIN_USER="deploy"
export ADMIN_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7YrtR3tfvCNWZ83k8JGdJxzha0esIKaszA/prM6asxbVRg/g4WpRFjIDRTIPcycynQ3teDjAeRXsz/Ri8bgfWQEMsAFS+M0PEQV14+qxUGeaB8AU/JodmZ1cjCEN961MAInvQnbUHYEEDDEkRo0CEG5ea4ztPvDCIBV3qW5MZbkHUuAF1s8Tpr7pO4OXkkngZEcAgUscemaQMGr/qR0fJECDnliRuGH3vFoJnZeh3ElTUM71eb3IQeMkaivQ+F1kUOZCufu59pCJbDPYF/Sk1sejv8QnUfs8f3CvuqElZ0uFjuWMgbNWRojcj1LB/TFK5M3M+94HAhzUJp/tkHDM9 chris@familyroberosn.com"

# Update and Upgrade  Apt Repository
apt-get update
apt-get -y upgrade

# Add basic packages for Template
apt-get -y install open-vm-tools openssh-server aptitude 

# "Removing openssh-server's host keys..."
rm -vf /etc/ssh/ssh_host_*

# Recreate host keys on next boot.
#add check for ssh keys on reboot...regenerate if neccessary
sed -i -e 's|exit 0||' /etc/rc.local
sed -i -e 's|.*test -f /etc/ssh/ssh_host_dsa_key.*||' /etc/rc.local
bash -c 'echo "test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server" >> /etc/rc.local'
bash -c 'echo "exit 0" >> /etc/rc.local'

# add user 'ADMIN_USER'. User is created during the Ubuntu installation.
# adduser $ADMIN_USER
 
# add public SSH key
rm -rf /home/$ADMIN_USER/.ssh
mkdir -m 700 /home/$ADMIN_USER/.ssh
chown $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.ssh
echo $ADMIN_PUBLIC_KEY > /home/$ADMIN_USER/.ssh/authorized_keys
chmod 600 /home/$ADMIN_USER/.ssh/authorized_keys
chown $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.ssh/authorized_keys
 
# add support for ssh-add
echo 'eval $(ssh-agent) > /dev/null' >> /home/$ADMIN_USER/.bashrc
 
# add user 'ADMIN_USER' to sudoers.  Sudoers is created during the Ubuntu installation.
#echo "$ADMIN_USER    ALL = NOPASSWD: ALL" > /etc/sudoers.d/$ADMIN_USER
#chmod 0440 /etc/sudoers.d/$ADMIN_USER

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
