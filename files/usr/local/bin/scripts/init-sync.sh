#!/bin/bash
# init_sync.sh: to initialize syncing

# https://stackoverflow.com/questions/13494302/export-user-env-variable-for-use-in-cron
USER=$(whoami)

# user name is like NERDY\aaditya.bagga
DOMAIN_NAME=$(echo "$USER" | cut -f 1 -d "\\")
DOMAIN_USER_NAME=$(echo "$USER" | cut -f 2 -d "\\")
LOCAL_FOLDER="/home/local/${DOMAIN_NAME}/${DOMAIN_USER_NAME}"
REMOTE_FOLDER="/home/roaming/${DOMAIN_NAME}/${DOMAIN_USER_NAME}"

# different behaviour based on size difference
SIZE_DIFF=0
if [ -d "$REMOTE_FOLDER" ]; then
	SIZE_LOCAL=$(du -d 1 --total --exclude=".osync_workdir" "$LOCAL_FOLDER" | grep total | tail -n 1 | cut -f 1)
	SIZE_REMOTE=$(du -d 1 --total --exclude=".osync_workdir" "$REMOTE_FOLDER" | grep total | tail -n 1 | cut -f 1)
	if [ "$SIZE_LOCAL" -gt "$SIZE_REMOTE" ]; then
		SIZE_DIFF=$((SIZE_LOCAL - SIZE_REMOTE))
	else
		SIZE_DIFF=$((SIZE_REMOTE - SIZE_LOCAL))
	fi
fi

# need to kill old notifications as they seem to persist
pkill "display-notification-repeatedly"
# CHECK IF USER DIRECTORY MOUNTED
if ! /usr/local/bin/scripts/check-nerdy-mount.sh; then
        logger "[nerdy-lan] User directory for $USER not mounted"
        /usr/local/bin/scripts/display-notification-repeatedly.sh &
else
	# try syncing user folder
	if [ "$SIZE_DIFF" -gt 100000 ]; then
		# more than 100 mb difference
		notify-send -t 30000 -a nerdy-lan -i info "Data sync initiated, may take some time..."
	else
		notify-send -t 10000 -a nerdy-lan -i info "Data sync initiated."
	fi
	if ! /usr/local/bin/scripts/sync-user-profile.sh -q; then
		notify-send -u critical -a nerdy-lan -i error "Failed to sync, contact system administrator for more info."
	fi
fi
