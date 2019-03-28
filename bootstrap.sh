#!/bin/bash
# mk (c) 2019
set -xeuo pipefail

/vagrant/install_cobbler.sh \
      && /vagrant/configure_cobbler.sh \
      && /vagrant/create_cobbler_profile_centOS7.sh
