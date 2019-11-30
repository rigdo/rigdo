#!/bin/sh

if [ "$1" = "" ]
then
	echo "addservice.sh service"
	exit 1
fi

service=$1
let ii=${#service}-1
instance=${service:$ii:1}
if [ "$instance" -eq "$instance" 2>/dev/null ]
then
	# instance is digit
	let nl=${#service}-1
	servicename=${service:0:$nl}
else
	servicename=$service
	instance=""
fi

tmpdir=/tmp/services

if [ -d /service/${servicename}${instance} ]
then
	echo "${servicename} alreaday added"
	exit 1
fi

echo "Scheduling ${servicename} #${instance} to start..."
cp -a /etc/sv/${servicename} ${tmpdir}/${servicename}${instance}
echo ${instance} >${tmpdir}/${servicename}${instance}/instancenum
# add to runsv
ln -s ${tmpdir}/${servicename}${instance} /var/service

