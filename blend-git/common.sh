#!/bin/bash

# Copyright 2017 Edmundo Carmona Antoranz
# Released under the terms of GPLv2

# get the full ID of a revision
function get_full_revision_id {
    res=$( git show --summary -q --pretty=%H $1 )
    if [ $? -ne 0 ]; then
        echo Error getting full revision ID for $1 >&2
        exit 1
    fi
    echo $res
}

# Get the tree object ID of a revision
function get_tree_object_id {
    tree=$( git cat-file -p $1 | grep tree | head -n 1 | sed 's/^tree*. //' )
    if [ $? -ne 0 ]; then
        echo Error getting the tree object ID for revision $1 >&2
        exit 1
    fi
    echo $tree
}

