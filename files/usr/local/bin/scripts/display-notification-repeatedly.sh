#!/bin/bash
# to display notification repeatedly

# in seconds
SLEEP_TIME=600

# message
MSG_TO_DISPLAY='User folder not mounted, data sync issues likely! Please logout and login or restart the system to ensure that the remote folder gets mounted.'

while true; do
	#notify-send -u critical -a nerdy-lan -i error "$MSG_TO_DISPLAY"
	notify-send -t 8000 -a nerdy-lan -i error "$MSG_TO_DISPLAY"
	sleep "$SLEEP_TIME"
done
