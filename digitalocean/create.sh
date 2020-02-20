#! /bin/bash
. ./common.sh

doctl compute droplet create ${INSTANCE_NAME} --image ubuntu-18-04-x64 --region fra1 --ssh-keys ee:a4:d1:c3:61:b1:7c:33:ce:49:a0:01:c5:a4:3b:09 --size 2gb --user-data-file ../setup.sh
sleep 20
IP=$(doctl compute droplet list | tail -n1 | awk '{print $3}')
echo "IP = ${IP}"
echo "Provisioning in progress..."

counter=0
max_attempts=600
test_endpoint="http://${IP}:9100"

until $(curl --output /dev/null --silent --fail --max-time 5 ${test_endpoint}); do
    if [ ${counter} -eq ${max_attempts} ]; then
       echo "Provisioning timed out."
       exit 1
    fi

    printf '.'
    counter=$(($counter+1))
    sleep 1
done

echo
echo "Provisioning finished, use the following IP to connect via x2go client:"
echo "${IP}"

