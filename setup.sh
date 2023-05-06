#! /bin/bash
set -e

REPO_NAME="terraform-x2go-firefox"
REPO_URL="https://github.com/AleksanderGrzybowski/${REPO_NAME}.git"
UBUNTU_PASSWORD="x2goletmein2020"

echo "Cloning ${REPO_URL}..."

git clone ${REPO_URL}
cd ${REPO_NAME}

echo "Installing Ansible..."

apt-get update
apt-get -y install ansible

echo "Running playbook..."

ansible-playbook -e "ubuntu_password=${UBUNTU_PASSWORD}" -i ./hosts playbook.yml

echo "Provisioning done."
