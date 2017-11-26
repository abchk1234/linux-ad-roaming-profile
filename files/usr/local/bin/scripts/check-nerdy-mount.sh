#!/bin/bash
# to check if user folder is mounted

# sometimes we check both if a domain folder is mounted
# and in case of multiple folders, that the correct folder is mounted!

# https://stackoverflow.com/questions/13494302/export-user-env-variable-for-use-in-cron
USER=$(whoami)

SERVER_HOSTNAME="nerdy.lan"
DOMAIN_NAME=$(echo "$USER" | cut -f 1 -d "\\")
DOMAIN_USER_NAME=$(echo "$USER" | cut -f 2 -d "\\")
REMOTE_FOLDER="/home/roaming/${DOMAIN_NAME}/${DOMAIN_USER_NAME}"
 
SEARCH_KEYWORDS=( "$SERVER_HOSTNAME" "$REMOTE_FOLDER" )

keywords_matched=0

for search_keyword in "${SEARCH_KEYWORDS[@]}"; do
	if ! mount | grep -q "$search_keyword"; then
		keywords_matched=1
		break
	fi
done

exit $keywords_matched
