#! /bin/bash
. ./common.sh

doctl compute droplet create ${INSTANCE_NAME} --image ubuntu-18-04-x64 --region fra1 --ssh-keys 41:14:e9:86:da:a7:42:c1:af:1d:52:4e:07:3b:57:b7 --size 2gb --user-data-file ../setup.sh
sleep 20
doctl compute droplet list | tail -n1 | awk '{print $3}'


