#!/bin/bash

# Update
sudo yum update -y

# Upgrade
sudo yum upgrade -y

# Install Docker
sudo amazon-linux-extras install -y docker
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl restart docker
sudo usermod -a -G docker ec2-user

#Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Not the best option to deploy app but i can't activate a new jenkins instance
mkdir /tmp/deploy
BUCKET_URL=${aws_s3_bucket.bucket_domain_name}
s3 cp s3://mattiafedele-terraform-artifacts/ /tmp/deploy --recursive

cd /tmp/deploy
docker-compose up -d
