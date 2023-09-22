#!/bin/bash

sudo mkdir home/ubuntu/company_name

cd home/ubuntu/company_name || exit

sudo mkdir auth

sudo cat provision.sh

echo '#!/bin/bash
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
apt install docker-ce
apt install docker-compose
apt-get install apache2 apache2-dev
apt install -y build-essential libxml2-dev
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod ssl' > provision.sh

sudo cat docker-compose.yml

echo 'version: "3.7"

services:
  pypi-server:
    build:
      context: ./pypiserver
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    volumes:
      - type: bind
        source: /home/ubuntu/company_name/auth
        target: /data/auth
      - type: volume
        source: pypi-server
        target: /data/packages
    command: -P . -a . /data/packages
#    With auth below:
#    command: -P /data/auth/.htpasswd -a update,download,list /data/packages
    restart: always

volumes:
  pypi-server:' > docker-compose.yml

sudo git clone https://github.com/paulr2021/pypiserver.git
