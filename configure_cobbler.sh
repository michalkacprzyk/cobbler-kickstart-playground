#!/bin/bash
# mk (c) 2019
# Basic configuration after installation
set -xeuo pipefail

MYDIR=$(dirname $(readlink -f "$0"))
source ${MYDIR}/variables.sh

#
# Functions
function less_secure(){
  setenforce 0
  sed -r -i 's/(SELINUX=)enforcing/\1permissive/' /etc/sysconfig/selinux 

  if [[ $(firewall-cmd --state 2>&1) = "running" ]] ; then
    firewall-cmd --add-port=80/tcp --permanent
    firewall-cmd --add-port=443/tcp --permanent
    firewall-cmd --add-service=dhcp --permanent
    firewall-cmd --add-port=69/tcp --permanent
    firewall-cmd --add-port=69/udp --permanent
    firewall-cmd --add-port=4011/udp --permanent
    firewall-cmd --reload
  fi
}

function cobbler_settings(){
  ex -V -s /etc/cobbler/settings <<EOF
:%s/^\(manage_dhcp:\).*/\1 1/
:%s/^\(manage_dns:\).*/\1 1/
:%s/^\(pxe_just_once:\).*/\1 1/
:%s/^\(server:\) .*/\1 ${IP}/
:%s/^\(next_server:\) .*/\1 ${IP}/
:update
:quit
EOF

  sed -r -i 's/^(module =) manage_bind/\1 manage_dnsmasq/' /etc/cobbler/modules.conf
  sed -r -i 's/^(module =) manage_isc/\1 manage_dnsmasq/' /etc/cobbler/modules.conf

  cobbler get-loaders
  systemctl start rsyncd ; systemctl enable rsyncd
  yum install -y debmirror fence-agents

  sed -r -i 's/(@dists.*)/#\1/' /etc/debmirror.conf 
  sed -r -i 's/(@arches.*)/#\1/' /etc/debmirror.conf
}

function dhcp_template(){
  ex -s /etc/cobbler/dhcp.template <<EOF
:%s/192\.168\.1/${SUBNET}/g
:%s/\(option routers\) .*/\1 ${IP};/
:%s/\(option domain-name-servers\) .*/\1 ${IP};/
:update
:quit
EOF

  ex -s /etc/cobbler/dnsmasq.template <<EOF
:%s/192\.168\.1/${SUBNET}/g
:update
:quit
EOF

  echo ${IP} cobbler >> /etc/hosts
  systemctl restart dnsmasq
}

function tftp(){
  sed -r -i 's/#(\t+enabled\t+\=)/\1 tftp/' /etc/xinetd.conf
  sed -r -i 's/(\t+disable\t+\=).*/\1 no/' /etc/xinetd.d/tftp
  systemctl restart xinetd
  systemctl enable xinetd
}

function cobbler_check(){
  systemctl restart cobblerd
  sleep 2
  cobbler sync
  cobbler check
}

#
# Execution
less_secure
cobbler_settings
dhcp_template
tftp
cobbler_check
