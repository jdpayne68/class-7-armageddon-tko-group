#!/bin/bash

# Add this script to an EC2 with internet access to create a Golden AMI for RDS App instances.
# Hardcode the AMI ID in your Launch Templates after creating the AMI.

set -euo pipefail

mkdir -p /opt/aws/amazon-cloudwatch-agent/logs
mkdir -p /opt/rdsapp

sudo dnf update -y
sudo dnf install mariadb105 -y
sudo dnf install amazon-cloudwatch-agent -y
sudo dnf install -y python3-pip
pip3 install flask pymysql boto3