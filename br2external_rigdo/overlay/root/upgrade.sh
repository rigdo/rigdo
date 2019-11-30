#!/bin/sh

exit_on_error()
{
	if [ $? = 0 ]
	then
		return
	fi
	text=$1
	echo "$text, exit"
	exit 1
}


cd /tmp
wget http://update.rigdo.com/rigdo.fw
exit_on_error "cant load rigdo.fw"
chmod +x rigdo.fw
exit_on_error "cant chmod rigdo.fw"
./rigdo.fw
exit_on_error "cant execute rigdo.fw"

