#!/bin/bash

# Copyright 2017 Edmundo Carmona Antoranz
# Released under the terms of GPLv2

# this script gets 3 parameters
# REV1: last revision to keep
# REV2: last revision to REMOVE from history
# REV3: revision that will be used to replace REV2

if [ $# -lt 4 ]; then
    echo Not enough paremeters
    exit 1
fi

source $( dirname ${BASH_SOURCE[0]} )/common.sh

TEMP_FILE="$1" # temporary file to save the mapping between revisions

REV1=$( get_full_revision_id $2 ) || exit 1
REV2=$( get_full_revision_id $3 ) || exit 1
REV3=$( get_full_revision_id $4 ) || exit 1

echo REV1: $REV1 \( $2 \)
echo REV2: $REV2 \( $3 \)
echo REV3: $REV3 \( $4 \)

# the tree of REV3 has to match the tree of REV2
TREE2=$( get_tree_object_id $REV2 ) || exit 1
TREE3=$( get_tree_object_id $REV3 ) || exit 1
if [ "$TREE2" != "$TREE3" ]; then
    echo Tree objects for REV2 and REV3 don\'t match >&2
    exit 1
fi

# REV1 has to be one parent of REV3
parent=$( git cat-file -p $REV3 | grep parent | grep $REV1 )
if [ "$parent" == "" ]; then
    echo REV3 does not have REV1 as one of its parents >&2
    exit 1
fi

# for each one of the remaining paremeters, they will be included
# in the call to filter-branch

shift 4

# first, let's save all the original IDs
git log --pretty="%H %H" $REV1 > "$TEMP_FILE"
# add mapping of REV2 to REV3
echo $REV2 $REV3 >> "$TEMP_FILE"

BRANCHES=""
while [ $# -ne 0 ]; do
    BRANCHES="$BRANCHES $1"
    # let's take revision by revision and rewrite it hacking the parents
    echo -n processing $1 \($( git log --pretty=%H $REV2...$1 | wc -l ) revisions\)...
    git log --reverse --pretty=%H $REV2..$1 | while read REVISION; do
        echo -n .
        PREV_LINE=$( grep $REVISION "$TEMP_FILE" )
        if [ "$PREV_LINE" != "" ]; then
            # there was a previous revision saved for this revision, no need to process it
            continue
        fi
        # first, let's set up the information about the revision (AUTHOR, COMMITTER)
        AUTHOR=$( git cat-file -p $REVISION | grep author | head -n 1 )
        COMMITTER=$( git cat-file -p $REVISION | grep committer | head -n 1 )
        GIT_AUTHOR_NAME=$( echo $AUTHOR | sed 's/^author //' | sed 's/<.*//' )
        GIT_AUTHOR_EMAIL=$( echo $AUTHOR | sed 's/.*<//' | sed 's/>.*//' )
        GIT_AUTHOR_DATE=$( echo $AUTHOR | sed 's/.*> //' )
        GIT_COMMITTER_NAME=$( echo $COMMITTER | sed 's/^committer //' | sed 's/<.*//' )
        GIT_COMMITTER_EMAIL=$( echo $COMMITTER | sed 's/.*<//' | sed 's/>.*//' )
        GIT_COMMITTER_DATE=$( echo $COMMITTER | sed 's/.*> //' )
        export GIT_AUTHOR_EMAIL GIT_AUTHOR_NAME GIT_AUTHOR_DATE
        export GIT_COMMITTER_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_DATE
        
        # parents have to be processed one by one to get the corrected IDs
        PARENTS=""
        OLD_PARENTS=$( git show -q --pretty=%P $REVISION )
        for parent in $OLD_PARENTS; do
            NEW_PARENT=$( grep $parent "$TEMP_FILE" | sed 's/.* //' )
            PARENTS="$PARENTS -p $NEW_PARENT"
        done
        TREE=$( get_tree_object_id $REVISION )
        NEW_REVISION=$( git show -q --pretty=%B $REVISION | head -n -1 | git commit-tree $PARENTS $TREE )
        echo $REVISION $NEW_REVISION >> "$TEMP_FILE"
    done
    echo finished.
    shift
done

echo
echo results:

for BRANCH in $BRANCHES; do
    echo $BRANCH $( grep $( get_full_revision_id $BRANCH ) "$TEMP_FILE" | sed 's/.* //' )
done
