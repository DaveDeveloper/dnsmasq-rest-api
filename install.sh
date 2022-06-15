#!/bin/sh

set -e

target=/opt/dnsmasq-rest-api/

echo "Installing dnsmasq-rest-api to $target."

git clone -b php7.1-aplpine-docker https://github.com/DaveDeveloper/dnsmasq-rest-api.git $target

ls -al $target
echo "Configuring dnsmasq."

#rc-service dnsmasq stop
#rc-service apache2 stop
ln -sf $target/config/dnsmasq/dnsmasq-rest-api.conf /etc/dnsmasq.d/dnsmasq-rest-api.conf
#rc-service dnsmasq start

echo "Allow dnsmasq-rest-api to send signal to dnsmasq"

#cp $target/config/sudo/dnsmasq /etc/sudoers.d/dnsmasq
#chmod 0440 /etc/sudoers.d/dnsmasq

echo "Configuring apache2"

sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf

ln -sf $target/config/apache2/dnsmasq-rest-api.conf /etc/apache2/conf.d/dnsmasq-rest-api.conf

chown -R apache $target/zones
cp $target/www/config.example.php $target/www/config.php

#rc-service apache2 restart

rc-update add apache2 default
rc-update add dnsmasq default

echo "Dnsmasq-rest-api installed."

#echo "Running tests."

#echo "* Listing zones"
#curl -s http://localhost/dnsmasq-rest-api/zones | grep "\\[" | grep "\\]"
#echo "* Adding records"
#curl -s -X POST http://localhost/dnsmasq-rest-api/zones/myTest/127.0.0.2/localhost.test | grep OK
#echo "* Reload dnsmasq"
#curl -s -X POST http://localhost/dnsmasq-rest-api/reload | grep OK
#echo "* Testing dns"
#nslookup localhost.test 127.0.0.1 | grep 127.0.0.2
#echo "* Removing test zone"
#curl -s -X DELETE http://localhost/dnsmasq-rest-api/zones/myTest | grep OK

#echo "Tests ok."
