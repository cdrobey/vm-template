#!/bin/bash
#
# Sysprep OS for vmware template creation.  
#
#

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
	
echo "Clearing bash history..."
cat /dev/null > /root/.bash_history
history -c

echo "Process complete..."
# poweroff
