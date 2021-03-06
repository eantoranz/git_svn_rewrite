#!/bin/bash

# copyright 2015 Edmundo Carmona Antoranz
# Released under the terms of GPLv2

# use this script as --commit-filter, like this:
# git filter-branch --commit-filter '/path/to/script/remap_ids.sh "$@"'

source $( dirname ${BASH_SOURCE[0]} )/find_user.sh

NEW_REV=$( git commit-tree "$@" )
echo $GIT_COMMIT $NEW_REV >> $SVN_REVISION_FILE
echo $NEW_REV

