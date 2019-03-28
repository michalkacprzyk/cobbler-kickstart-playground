#!/bin/bash
# mk (c) 2019
# Create a sample cobbler profile
set -xeuo pipefail

MYDIR=$(dirname $(readlink -f "$0"))
source ${MYDIR}/variables.sh

cd ${WORKDIR}
test -f ${ISO} || wget ${ISO_URL}

mkdir /mnt/iso
mount -o loop ${ISO} /mnt/iso/
cobbler import --arch=x86_64 --path=/mnt/iso --name=CentOS7
cobbler distro list
cobbler distro report --name=CentOS7-x86_64

cp CentOS7.ks /var/lib/cobbler/kickstarts/
cobbler profile edit --name=CentOS7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/CentOS7.ks --kopts inst.sshd
cobbler sync

cat <<EOT
 * The target machine will need at least 1.5 GB RAM.
 * Make sure it is connected to the same network.
 * Installation will not start automatically
   * Will require one down arrow keypress
   * To change edit /etc/cobbler/pxe/pxedefault.template
     * Move local below \$pxe_menu_items ande remove MENU DEFAULT line
 * Installation can be observed via SSH, check sshpw comment in CentOS7.ks file
 * After installation is finished and target machine reboots
   * It is ready for provisioning via SSH for example with ansible
   * yum install -y ansible 
   * ansible all -i 192.168.10.115, -m ping --become-user=cobbler -k
EOT
