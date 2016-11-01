#!/bin/bash

#This script takes all the files in www and base64 encodes them
#It then plugs them into the preseed file so we don't need to reference from
#anywhere else

CURRENT_DIR=$(dirname $0)

LATE_COMMAND="echo 'Processing scripts'" 
LATE_COMMAND="$LATE_COMMAND; in-target bash -c 'mkdir -p /opt/firstboot_scripts'"

for file in $CURRENT_DIR/../files/firstboot_scripts/*
do
	LATE_COMMAND="$LATE_COMMAND; in-target bash -c 'export http_proxy="";curl http://192.168.87.254/firstboot_scripts/$(basename $file) -o /opt/firstboot_scripts/$(basename $file)'" 
done

#Now add the order to call them in
LATE_COMMAND="$LATE_COMMAND; in-target bash -c 'chmod +x /opt/firstboot_scripts/*.sh'"
LATE_COMMAND="$LATE_COMMAND; in-target bash -c '/opt/firstboot_scripts/desktop-bootstrap.sh'"

echo "d-i preseed/late_command			string $LATE_COMMAND"
