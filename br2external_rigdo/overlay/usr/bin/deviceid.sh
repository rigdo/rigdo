#!/bin/sh

#
HW=`cat /proc/cpuinfo  | grep Hardware | awk -F ':' '{print $2}' | tr -d ' '`
HWVER=`cat /proc/cmdline | tr ' ' '\n' | grep HWVER | awk -F '=' '{print $2}'`
#VERSION -> rootfs ver 
if [ -f /etc/version ]
then
	. /etc/version
fi
#CUSTOMER
if [ -f /etc/customer ]
then
	. /etc/customer
fi

separator=${SEPARATOR:-"_"}
sep=""
id="";
idx=0
content=${1:-"abcd"}
while [ 1 ]
do
	c=${content:${idx}:1}
	if [ "$c" = "" ]; then
		break;
	fi
	case $c in
	a)	
		id="${id}${sep}${HW}"
		sep=$separator
		;;
	b)
		id="${id}${sep}${HWVER}"
		sep=$separator
		;;
	c)
		id="${id}${sep}${VERSION}"
		sep=$separator
		;;		
	d)
		id="${id}${sep}${CUSTOMER}"
		sep=$separator
		;;
	esac
	idx=$((idx+1))
done

echo "${id}"

