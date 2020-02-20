#! /bin/bash
set -e

REPO_NAME="terraform-x2go-firefox"
REPO_URL="https://github.com/AleksanderGrzybowski/${REPO_NAME}.git"
UBUNTU_PASSWORD="x2goletmein2020"

git clone ${REPO_URL}
cd ${REPO_NAME}

apt-get update
apt-get -y install ansible

ansible-playbook -e "ubuntu_password=${UBUNTU_PASSWORD}" -i ./hosts playbook.yml

