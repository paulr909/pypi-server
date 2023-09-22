# Setup Notes
Domain Name: [https://theukdomain.uk/buy-a-domain/?domain=company_name-pypi.uk](https://theukdomain.uk/buy-a-domain/?domain=company_name-pypi.uk)

Log into ubuntu server.
```shell
ssh -i "~/.ssh/company_name-pypi-server-kp.pem" ubuntu@ec2-13-40-244-102.eu-west-2.compute.amazonaws.com
```

Change known host, usually delete the last in the list (if required).
```shell
sudo nano ~/.ssh/known_hosts
```

## Install PyPi Server
[https://testdriven.io/blog/private-pypi/](https://testdriven.io/blog/private-pypi/)

Create provision.sh file, copy contents and run on Ubuntu server:
```shell
sudo nano provision.sh
```
Run provision.sh to install required packages, you will be prompted to accept Y/N:
```shell
sudo sh provision.sh
```

## Install Docker on Ubuntu
[https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)

```shell
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

sudo apt install docker-ce

sudo apt install docker-compose

docker-compose --version

sudo systemctl status docker
```

## Install Apache Server

[https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04)

```shell
sudo apt-get install apache2 apache2-dev

# Check apache2 status
sudo systemctl status apache2

# Check logs
nano /var/log/apache2/error.log
```

## If using Authentication outside VPN

Create PyPi user in auth directory:
```shell
sudo htpasswd -sc .htpasswd company_name-user
```

Create additional users in auth directory:
```shell
sudo htpasswd -s .htpasswd pro-user
```

Clone the forked repository:
```shell
git clone https://github.com/paulr2021/pypiserver.git
```

Add the docker-compose.yml file, then run inside company_name directory:
```shell
sudo docker-compose up -d --build
```

Proxy Pass settings:
[https://www.digitalocean.com/community/tutorials/how-to-use-apache-http-server-as-reverse-proxy-using-mod_proxy-extension](https://www.digitalocean.com/community/tutorials/how-to-use-apache-http-server-as-reverse-proxy-using-mod_proxy-extension)

Install Packages:
```shell
sudo apt install -y build-essential libxml2-dev

sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
sudo a2enmod proxy_html

sudo nano /etc/apache2/sites-enabled/000-default.conf
```

```shell
# company_name PyPi Server Settings Below:
ProxyPreserveHost On
ProxyPass / http://13.40.244.102:8080/
ProxyPassReverse / http://13.40.244.102:8080/

ServerName localhost
```
Restart Apache Server:
```shell
sudo systemctl restart apache2
```

Continuous Integration / CD:
[https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/)

## Upload your Package
```shell
pip install twine

twine upload --repository-url http://<PUBLIC-IP-ADDRESS> dist/*
```

## Tutorial on Creating Custom Python Packages
[https://packaging.python.org/en/latest/tutorials/packaging-projects/](https://packaging.python.org/en/latest/tutorials/packaging-projects/)

Install Your Custom Package:
```shell
pip install --index-url http://13.40.244.102 muddy_wave --trusted-host 13.40.244.102
```