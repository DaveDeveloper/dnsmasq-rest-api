dnsmasq-rest-api
================

[![Build Status](http://travis-ci.org/bpaquet/dns-masq-rest-api.png)](http://travis-ci.org/bpaquet/dnsmasq-rest-api)

Dead simple REST Api for controlling (dnsmasq)[http://www.thekelleys.org.uk/dnsmasq/doc.html] server.

Why in PHP ? Because it's easy to deploy : no rbenv, ruby, java or pyhton lib to install !

Installation
---

This procedure has been tested under Ubuntu 12.04.

Requirments :
* Install dnsmasq
* Install and configure your PHP Server

Automatic procedure :

```
sudo git clone https://github.com/bpaquet/dnsmasq-rest-api.git /opt/dnsmasq-rest-api
cd /opt/dnsmasq-rest-api
sudo ./install.sh
```

Manual procedure :

* Checkout dnsmasq-rest-api

```
sudo git clone https://github.com/bpaquet/dnsmasq-rest-api.git /opt/dnsmasq-rest-api
```

* Update your dnsmasq config to use zones files provided by dnsmasq-rest-api

```
sudo ln -s /opt/dnsmasq-rest-api/config/dnsmasq/dnsmasq-rest-api.conf /etc/dnsmasq.d/dnsmasq-rest-api.conf
sudo /etc/init.d/dnsmasq restart
```

* Expose dnsmasq-rest-api in your PHP Server

```
sudo ln -s /opt/dnsmasq-rest-api/config/apache2/dnsmasq-rest-api.conf /etc/apache2/conf.d/dnsmasq-rest-api.conf
sudo /etc/init.d/apache2 restart
sudo chown -R www-data /opt/dnsmasq-rest-api/zones
sudo cp /opt/dnsmasq-rest-api/www/config.example.php /opt/dnsmasq-rest-api/www/config.php
```

* Allow your web server to reload dnsmasq config

```
sudo cp /opt/dnsmasq-rest-api/config/sudo/dnsmasq /etc/sudoers.d/dnsmasq
sudo chmod 0440 /etc/sudoers.d/dnsmasq
```

* Test all is working fine

```
$ curl http://localhost/dnsmasq-rest-api/zones
[]
$ curl http://localhost/dnsmasq-rest-api/zones/myTest/127.0.0.1/localhost.test
OK Record added
$ curl http://localhost/dnsmasq-rest-api/reload

$ host localhost.test 127.0.0.1

$ curl -X DELETE http://localhost/dnsmasq-rest-api/zones/myTest
OK Zone deleted
```

API
---

For each zone, dnsmasq-rest-api will write a file (named by the zone name) in the hosts dnsmasq directory.

Each zone can contains multiples lines, like a standard hosts file.

* List zones

```
$ curl http://localhost/dnsmasq-rest-api/zones
["myZone"]
```

* Delete zone

```
$ curl -X DELETE http://localhost/dnsmasq-rest-api/zones/myZone
OK Zone deleted
```

* There is no create zone command. Just add a record into a new zone

```
$ curl http://localhost/dnsmasq-rest-api/zones/myZone/records/127.0.0.1/localhost
OK Record added
```

* List zone records

```
$ curl http://localhost/dnsmasq-rest-api/zones/myZone
{"127.0.0.1":["localhost"]}
```

* Multiple host for same IP is supported

```
$ curl http://localhost/dnsmasq-rest-api/zones/myZone/records/127.0.0.1/localhost2
OK Record added
$ curl http://localhost/dnsmasq-rest-api/zones/myZone
{"127.0.0.1":["localhost","localhost2"]}
```


