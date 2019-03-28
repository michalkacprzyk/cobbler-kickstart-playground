# mk (c) 2019
# Install cobbler from sources with full control over the python stack
set -xeuo pipefail

#
# cobbler
yum install -y  epel-release
yum install -y  createrepo \
                dnsmasq \
                genisoimage \
                git \
                gcc \
                libusal \
                mod_wsgi \
                mod_ssl \
                make \
                python-deltarpm \
                pykickstart \
                python-virtualenv \
                PyYAML \
                python-cheetah \
                python2-pyyaml \
                python-netaddr \
                python2-simplejson \
                syslinux \
                tftp-server \
                xinetd

mkdir -p /opt/cobbler
cd /opt/cobbler

git clone https://github.com/cobbler/cobbler.git
cd /opt/cobbler/cobbler
git checkout release28
make install

service cobblerd restart && systemctl enable cobblerd
service httpd restart && systemctl enable httpd

#
# cobbler_web
cd /opt/cobbler
virtualenv cobbler_web_venv
set +u
source cobbler_web_venv/bin/activate
set -u

pip install cheetah \
            django==1.7 \
            simplejson \
            ipaddress \
            netaddr \
            pyyaml \
            six

yum install -y libcurl-devel
export PYCURL_SSL_LIBRARY=nss
pip install pycurl --compile --no-cache-dir
pip install urlgrabber

cd /opt/cobbler/cobbler
make webtest

ex -s /etc/httpd/conf.d/cobbler_web.conf <<EOF 
:%s!^\(WSGIDaemonProcess.*\)!\1 python-home=/opt/cobbler/cobbler_web_venv/!
:%s!/usr/share/cobbler/web/!/opt/cobbler/cobbler/web/!g 
:update
:quit
EOF

sed -ri 's/^SECRET_KEY.*/SECRET_KEY="not empty"/' /opt/cobbler/cobbler/web/settings.py

systemctl daemon-reload
service httpd restart
service cobblerd restart
