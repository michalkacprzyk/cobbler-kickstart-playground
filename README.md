# cobbler-kickstart-playground

## What is?

Automated creation of a *cobbler* master Virtual Machine, installed from sources
and a sample *kickstart* profile. The setup can automatically provision other
machines via *PXE* network boot.

## What for?

Can be used as a playground for prototyping and testing *cobbler* and *kickstart* deployments.

Automated installation from sources was inspired by mismatch in libraries version
in *epel* repositories for *CentOS7*, between *cobbler-web* and *django*,
resulting in a broken *cobbler-web* installation. Also, having the source deployment
process in place, makes some prototyping experiments easier.

## How to?
### Cobbler Master VM
Assuming that [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
and [Vagrant](https://www.vagrantup.com/downloads.html) are installed,
and we are in the cloned directory of this repository

```bash
# Create the cobbler master VM
vagrant up

# (optional) Connect to the VM
vagrant ssh

# Stop the VM
vagrant halt

# Destroy the VM (assuming no changes inside, it is easy enough to recreate)
vagrant destroy
```

### Expected result
In my case *time vagrant up* ends with the following message:
```
master: running python trigger cobbler.modules.manage_genders
master: running python trigger cobbler.modules.scm_track
master: running shell triggers from /var/lib/cobbler/triggers/change/*
master: *** TASK COMPLETE ***
master: + cat
master:  * The target machine will need at least 1.5 GB RAM.
master:  * Make sure it is connected to the same network.
master:  * Installation will not start automatically
master:    * Will require one down arrow keypress
master:    * To change edit /etc/cobbler/pxe/pxedefault.template
master:      * Move local below $pxe_menu_items ande remove MENU DEFAULT line
master:  * Installation can be observed via SSH, check sshpw comment in CentOS7.ks file
master:  * After installation is finished and target machine reboots
master:    * It is ready for provisioning via SSH for example with ansible
master:    * yum install -y ansible
master:    * ansible all -i 192.168.10.115, -m ping --become-user=cobbler -k

real	7m41,830s
user	1m21,678s
sys	0m15,322s
```

Web interface should be available at https://192.168.10.5/cobbler_web (l: cobbler, p: cobbler).

### Testing Automatic Network Installation
We will use *VirtualBox GUI* here to keep it simple

  - Open VirtualBox GUI
  - New -> Name: "PXE Test", Type: "Linux", Version: "RedHat (64-bit)" -> Next
  - Memory: 2048 -> Next
  - Create a virtual hard disk now -> Create -> VDI -> Next
  - "Dynamically allocated" -> Next -> Create
  - Settings -> System -> Boot Order -> Select "Network" and move to the top
  - Settings -> Network -> Adapter 1 -> Attached to: "Host-only Adapter", Name: "vboxnet1"

## What if?

  - The code was created and tested on [Linux Mint](https://linuxmint.com/)
    - VirtualBox 5.2.18
    - Vagrant 2.2.3
  - References
    - [Cobbler Manual - Version 2.8.x](http://cobbler.github.io/manuals/2.8.0/)
    - [Cobbler Quickstart Guide](http://cobbler.github.io/manuals/quickstart/)
    - [Cobbler Installing From Source](http://cobbler.github.io/manuals/2.8.0/2/3_-_Installing_From_Source.html)
    - [Virtual Environments — mod_wsgi 4.6.5 documentation](https://modwsgi.readthedocs.io/en/develop/user-guides/virtual-environments.html)
    - [1.3. Automated Installation - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-automated-installation)
    - [26.3. Kickstart Syntax Reference - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax)
    - [4.6 Creating a Kickstart Profile in Cobbler](https://docs.oracle.com/cd/E92593_01/E64608/html/section_ymj_qwk_xr.html)
