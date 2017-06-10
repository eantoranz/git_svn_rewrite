#!/bin/bash

# copyright 2017 Edmundo Carmona Antoranz
# Released under the terms of GPLv2

# Script to move remote branches to their new locations

# This script gets at least 2 parameters:
# Revisions file
# All the branches that have to be moved

if [ $# -lt 2 ]; then
	echo Not enough paremeters
	exit 1
fi

source $( dirname ${BASH_SOURCE[0]} )/common.sh

REVISIONS_FILE="$1"

shift 1

while [ $# -ne 0 ]; do
	BRANCH="$1"

	OLD_REV=$( get_full_revision_id "$BRANCH" )
	grep $OLD_REV "$REVISIONS_FILE" | while read old NEW_REV; do
		git update-ref refs/remotes/"$BRANCH" $NEW_REV
		echo Branch $BRANCH has moved from $OLD_REV to $NEW_REV
	done

	shift 1
done


