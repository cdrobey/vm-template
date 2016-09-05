#!/bin/bash
USER=ubuntu

# Setup SSH Keys
dpkg-reconfigure openssh-server > /dev/null

# Add Ansible Keys to deploy User
cat id_rsa.deploy > ~$USER/.ssh/authorized_keys

# Clean up rc.local from initial boot
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

exit 0
EOF
