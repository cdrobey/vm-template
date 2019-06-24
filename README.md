# vm-template

## Table of Contents

1. [Building an Ubuntu VM Template](#building-an-ubuntu-vm-template)
2. [Building an Centos VM Template](#building-an-centos-vm-template)

# VM-Template Project
This project cleanses minimal installations of Ubuntu/Centos for creating VM Templates.  The scripts allow you to quickly build new templates for deployment where Puppet owns the provisioning of the system.

## Building an Ubuntu VM Template
The script vm-dehydrate-ubuntu.sh removes all system generated files and deletes system network devices from an Ubuntu 18.04 Installation.

If you are using this to build a golden image for vsphere 6.5 a VMware KB exists that must be followed to properly customize the image.

https://kb.vmware.com/s/article/54986

## Building an Centos VM Template
The script vm-dehydrate-centos.sh removes all system generated files and deletes system network devices from a Centos 7 Installation.
