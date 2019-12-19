#! /bin/bash
. ./common.sh

doctl compute droplet delete ${INSTANCE_NAME} --force

