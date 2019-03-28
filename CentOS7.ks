# mk (c) 2019
# Basic minimal install of CentOS7
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax

# Use HTTP installation media
## cdrom
url --url="http://cobbler/cblr/links/CentOS7-x86_64"

# Use text install
## graphical
text

# Installation logging level
logging level=info

# System authorization information
auth --enableshadow --passalgo=sha512

# Root password
rootpw --iscrypted $6$nFmFAfUu83LgRekp$iJeGPVN6yYXjt01gZltfAv0/UNfH6M3gYDf2UBqVp2r28YgK5yKPo51YjNVIhjOsPdnBTPQ0y61TdyhQhpCJk0
# Sudo user
user --groups=wheel --name=cobbler --password=$6$FXhkxVzu1DCoE293$ZkrtknvUnih5ug19PNP5kgkjw4bap9Uzr1qFww9JklYz3j/j9lNQ.TUuzz9JSgrn9FYzFE9/3ZgUA0MBG12PB/ --iscrypted --gecos="cobbler"

# SELinux configuration
selinux disabled

# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on

# Firewall configuration
firewall --disabled

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# System timezone
timezone Europe/London --isUtc

# Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda

# System services
services --disabled="chronyd"

# Partition clearing information
clearpart --all --initlabel --drives=sda
autopart --type=lvm

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

# Reboot after installation
reboot

%packages
@^minimal
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
