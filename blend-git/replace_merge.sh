#!/bin/bash

# 2017 copyright Edmundo Carmona Antoranz
# released under the terms of GPLv2

# Script to create a new real "merge" revision that will be used to replace a
# section of revisions that were created and are _not_ a merge

# It gets 5 parameters
# REV1: last revision that is _not_ part of the merge (just before the merge started)
# REV2: last revision of the merge process.
# REV3: Branch that will be included in the history of the new revision
# Author Name
# Author Email

# New revision will have
# - REV1 and REV3 as parents
# - The same tree object of REV2

# The output will be the ID of the newly created revision (can be used as REV3 when calling blend-git.sh)

if [ $# -lt 5 ]; then
    echo Not enough parameters
    exit 1
fi

# creating squash revision
( git checkout --detach -q $1 && git merge -q --squash $2 && git commit --no-edit ) > /dev/null
if [ $? -ne 0 ]; then
    echo There was an error squashing $1..$2
    exit 1
fi

source $( dirname ${BASH_SOURCE[0]} )/common.sh

TREE=$( get_tree_object_id HEAD )

# creating new revision
git show -q --pretty=%B HEAD | head -n -1 | GIT_AUTHOR_NAME="$4" GIT_AUTHOR_EMAIL="$5" git commit-tree -p $1 -p $3 $TREE
