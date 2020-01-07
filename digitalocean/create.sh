#! /bin/bash
. ./common.sh

doctl compute droplet create ${INSTANCE_NAME} --image ubuntu-18-04-x64 --region fra1 --ssh-keys ee:a4:d1:c3:61:b1:7c:33:ce:49:a0:01:c5:a4:3b:09 --size 2gb --user-data-file ../setup.sh
sleep 20
doctl compute droplet list | tail -n1 | awk '{print $3}'


