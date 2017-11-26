#!/bin/bash
# to connect to active directory domain if not connected

# VARS
DOMAIN_NAME="nerdy.lan"

# Check if domain can be resolved
if ! host "$DOMAIN_NAME"; then
	echo "host $DOMAIN_NAME not found"
	logger "[${DOMAIN_NAME}] failed to resolve $DOMAIN_NAME"
	exit 1
fi

if ! /opt/pbis/bin/get-status | grep -q "$DOMAIN_NAME"; then
	logger "[${DOMAIN_NAME}] attempting to join to $DOMAIN_NAME"
	if /opt/pbis/bin/domainjoin-cli join --disable ssh "$DOMAIN_NAME" administrator "admin1@nerdy123!"; then
		logger "[${DOMAIN_NAME}] joined $DOMAIN_NAME"
	else
		logger "[${DOMAIN_NAME}] failed to joined $DOMAIN_NAME"
		exit 1
	fi
fi
