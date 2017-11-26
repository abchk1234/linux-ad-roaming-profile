#!/bin/bash
# to sync user profile to remote roaming profile

# https://stackoverflow.com/questions/13494302/export-user-env-variable-for-use-in-cron
USER=$(whoami)

# user name is like NERDY\aaditya.bagga
DOMAIN_NAME=$(echo "$USER" | cut -f 1 -d "\\")
DOMAIN_USER_NAME=$(echo "$USER" | cut -f 2 -d "\\")
LOCAL_FOLDER="/home/local/${DOMAIN_NAME}/${DOMAIN_USER_NAME}"
REMOTE_FOLDER="/home/roaming/${DOMAIN_NAME}/${DOMAIN_USER_NAME}"
QUIET=1
VERBOSE=1
#BACKGROUND=1

# cron does not have $USER
# https://stackoverflow.com/questions/13494302/export-user-env-variable-for-use-in-cron
USER=$(whoami)

# user name may be like aaditya.bagga if login without domain!
if ! echo "$USER" | grep -q '\\'; then
	echo "DOMAIN_NAME not found!"
	exit 1
fi

# Handle cmd line options
while getopts "qvh" opt
do
	case "$opt" in
	q) QUIET=0;;
	v) VERBOSE=0;;
	*) ;;
	esac
done

# arguments for osync
OSYNC_ARGS=
if [ "$QUIET" -eq 0 ]; then
	OSYNC_ARGS="${OSYNC_ARGS} --silent --errors-only"
else
	OSYNC_ARGS="${OSYNC_ARGS} --summary"
fi
if [ "$VERBOSE" -eq 0 ]; then
	OSYNC_ARGS="${OSYNC_ARGS} --verbose --stats"
fi
OSYNC_BIN=/usr/local/bin/osync.sh

# running in background based on size difference?
#SIZE_LOCAL=$(du -d 1 --total --exclude=".osync_workdir" "$LOCAL_FOLDER" | grep total | tail -n 1 | cut -f 1)
#SIZE_REMOTE=$(du -d 1 --total --exclude=".osync_workdir" "$LOCAL_FOLDER" | grep total | tail -n 1 | cut -f 1)

# CHECK IF USER DIRECTORY MOUNTED
if ! /usr/local/bin/scripts/check-nerdy-mount.sh; then
	msg="Remote folder not mounted!"
	echo "$msg"
	logger "[nerdy-lan] $msg"
	exit 1
else
	logger "[nerdy-lan] Starting sync."
	#csync "$LOCAL_FOLDER" "$REMOTE_FOLDER"
	RSYNC_EXCLUDE_FROM="${LOCAL_FOLDER}/.osync/exclude.list" $OSYNC_BIN osync.sh --initiator="$LOCAL_FOLDER" --target="$REMOTE_FOLDER" $OSYNC_ARGS
	retval=$?
	if [ "$retval" -eq 0 ]; then
		logger "[nerdy-lan] Sync done."
	else
		logger "[nerdy-lan] Sync failed!"
		exit 1
	fi
fi
