#!/bin/bash

# Setup SSH Keys
dpkg-reconfigure openssh-server > /dev/null

# Add Ansible Keys to deploy User
mkdir ~ubuntu/.ssh/
cat /etc/vm-template/id_rsa.pub.deploy > ~ubuntu/.ssh/authorized_keys
chmod 600 ~ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu  ~ubuntu/.ssh/

# Add Python to manage using Ansible
apt-get update
apt-get install python

# Clean up rc.local from initial boot
cat << EOF > /etc/rc.local
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

exit 0
EOF
