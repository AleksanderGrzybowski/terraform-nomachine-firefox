#!/bin/bash

#
# This was taken from https://github.com/pacon-vib/terraform-wait-for-http-demo/blob/main/wait_for_url.sh
#


url="http://$1:80"
sleep_time=10
tries_remaining=60

echo "Starting waiting script for URL ${url} sleep_time = ${sleep_time} tries = ${tries_remaining}." >&2

while true; do
    echo "Trying ${url} tries_remaining = ${tries_remaining}..." >&2 
    curl -s -f "${url}" > /dev/null
    exit_code="$?"
    echo "curl exit code = ${exit_code}" >&2
    if [ "${exit_code}" == 0 ]; then
        break
    fi
    ((tries_remaining -= 1))
    if [ "${tries_remaining}" -le 0 ]; then
        echo "Exhausted retries, exiting." >&2 
        exit 1
    fi
    sleep ${sleep_time}
done

# Send state back to Terraform for successful completion
echo '{"url": "'"$1"'"}'
exit 0
