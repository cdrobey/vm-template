# some variables
export ADMIN_USER="centos"
export ADMIN_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7YrtR3tfvCNWZ83k8JGdJxzha0esIKaszA/prM6asxbVRg/g4WpRFjIDRTIPcycynQ3teDjAeRXsz/Ri8bgfWQEMsAFS+M0PEQV14+qxUGeaB8AU/JodmZ1cjCEN961MAInvQnbUHYEEDDEkRo0CEG5ea4ztPvDCIBV3qW5MZbkHUuAF1s8Tpr7pO4OXkkngZEcAgUscemaQMGr/qR0fJECDnliRuGH3vFoJnZeh3ElTUM71eb3IQeMkaivQ+F1kUOZCufu59pCJbDPYF/Sk1sejv8QnUfs8f3CvuqElZ0uFjuWMgbNWRojcj1LB/TFK5M3M+94HAhzUJp/tkHDM9 chris@familyroberosn.com"
 
# install necessary and helpful components
yum -y install net-tools nano vim deltarpm wget bash-completion yum-plugin-remove-with-leaves yum-utils git
 
# install VM tools and perl for VMware VM customizations
yum -y install open-vm-tools perl
 
# Stop logging services
systemctl stop rsyslog
service auditd stop
 
# Remove old kernels
package-cleanup -y --oldkernels --count=1
 
# Clean out yum
yum clean all
 
# Force the logs to rotate & remove old logs we don’t need
/usr/sbin/logrotate /etc/logrotate.conf --force
rm -f /var/log/*-???????? /var/log/*.gz
rm -f /var/log/dmesg.old
rm -rf /var/log/anaconda
 
# Truncate the audit logs (and other logs we want to keep placeholders for)
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby
 
# Remove the traces of the template MAC address and UUIDs
sed -i '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-e*
 
# enable network interface onboot
sed -i -e 's@^ONBOOT="no@ONBOOT="yes@' /etc/sysconfig/network-scripts/ifcfg-e*
 
# Clean /tmp out
rm -rf /tmp/*
rm -rf /var/tmp/*
 
# Remove the SSH host keys
rm -f /etc/ssh/*key*
 
# configure sshd_config to only allow Pubkey Authentication
sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication|PermitEmptyPasswords) (yes|no)/\1 no/' /etc/ssh/sshd_config
sed -i -r 's/^#?(PubkeyAuthentication) (yes|no)/\1 yes/' /etc/ssh/sshd_config
 
# add user 'ADMIN_USER'
adduser $ADMIN_USER
 
# add public SSH key
mkdir -m 700 /home/$ADMIN_USER/.ssh
chown $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.ssh
echo $ADMIN_PUBLIC_KEY > /home/$ADMIN_USER/.ssh/authorized_keys
chmod 600 /home/$ADMIN_USER/.ssh/authorized_keys
chown $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.ssh/authorized_keys
 
# add support for ssh-add
echo 'eval $(ssh-agent) > /dev/null' >> /home/$ADMIN_USER/.bashrc
 
# add user 'ADMIN_USER' to sudoers
echo "$ADMIN_USER    ALL = NOPASSWD: ALL" > /etc/sudoers.d/$ADMIN_USER
chmod 0440 /etc/sudoers.d/$ADMIN_USER
 
# Remove the root user’s SSH history
rm -rf ~root/.ssh/
rm -f ~root/anaconda-ks.cfg
 
# remove the root password
passwd -d root
 
# for support guest customization of CentOS 7 in vSphere 5.5 and vCloud Air
# mv /etc/redhat-release /etc/redhat-release.old && touch /etc/redhat-release && echo 'Red Hat Enterprise Linux Server release 7.0 (Maipo)' > /etc/redhat-release
 
# Remove the root user’s shell history
history -cw
 
# shutdown
# init 0
