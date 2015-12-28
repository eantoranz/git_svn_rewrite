#!/bin/bash

# copyright 2015 Edmundo Carmona Antoranz
# Released under the terms of GPLv2

# use this script as --commit-filter, like this:
# git filter-branch --commit-filter '/path/to/script/remap_ids.sh "$@"'

export GIT_AUTHOR_NAME="Test User"
NEW_REV=$( git commit-tree "$@" );
echo revision $GIT_COMMIT $NEW_REV >&2;
echo $NEW_REV

