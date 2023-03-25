#!/bin/bash

process=""

#waiting for polybar to appear
while [ -z "$process" ]
do
	sleep 1
	process=$(pgrep -x polybar)
done

#check if errors exist
message=$(cat ~/.xsession-errors | grep 'Disabling module "ewmh"')
process=$(pgrep -x polybar)


#what if errors exist
if [ -z "$process" ] && [ -z "$message" ] ; then
	echo "No polybar and no error"
else
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
	
	# launch polybar again
	sh ~/.config/polybar/launch.sh	
fi

