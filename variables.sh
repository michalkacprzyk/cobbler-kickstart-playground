#!/bin/bash
# mk (c) 2019

# Assuming netmask /24
# Also check Vagrantfile
SUBNET=192.168.10
IP=${SUBNET}.5

WORKDIR="/vagrant"
ISO="CentOS-7-x86_64-Minimal-1810.iso"
ISO_URL="http://repo.uk.bigstepcloud.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso"
