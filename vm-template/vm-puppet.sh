#!/bin/bash

PM=puppet.fr.lan

ping -c 1 $PM > /dev/null 2>&1

if [ $? -eq 0 ]
then
   curl -k https://$PM:8140/packages/current/install.bash | sudo bash
   echo Check!
fi
