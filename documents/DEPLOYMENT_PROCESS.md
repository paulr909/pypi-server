# Deployment Process

Create Key-Pair and update the "key_name" value in ec2.tf

Run Terraform:
```shell
terraform init

terraform apply --auto-approve
```

Log into ubuntu server.
```shell
ssh -i "~/.ssh/company_name-pypi-server-kp.pem" ubuntu@<update-path-here>.eu-west-2.compute.amazonaws.com
```

CD into company_name directory to install packages, run provision.sh, you will be prompted to accept [Y/n]:
```shell
sudo sh provision.sh
```

Edit Apache Config:
```shell
sudo nano /etc/apache2/sites-enabled/000-default.conf
```

Comment out settings apart from log file paths and add details below:
```shell
# company_name PyPi Server Settings Below:
ProxyPreserveHost On
ProxyPass / http://<IP-ADDRESS>:8080/
ProxyPassReverse / http://<IP-ADDRESS>:8080/

ServerName localhost
```

Restart Apache Server:
```shell
sudo systemctl restart apache2
```

CD into company_name directory run command below:
```shell
sudo docker-compose up -d --build
```
