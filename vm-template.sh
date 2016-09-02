#!/bin/bash
PM=puppet.fr.lan

# Setup SSH Keys
dpkg-reconfigure openssh-server > /dev/null

# Setup Puppet
ping -c 1 $PM > /dev/null 2>&1

if [ $? -eq 0 ]
then
   curl -k https://$PM:8140/packages/current/install.bash | sudo bash
   echo Check!
fi
