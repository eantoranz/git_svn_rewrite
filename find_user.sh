#!/bin/bash

# copyright 2015 Edmundo Carmona Antoranz
# released under the terms of GPLv2

# svn authors file will be in environment variable SVN_AUTHORS

author_line=$( egrep '^'$GIT_AUTHOR_NAME' {0,}=' $SVN_AUTHORS | $( dirname ${BASH_SOURCE[0]} )/parse_user.py )

# first word will always be the email
# the rest will always be the name of the developer

export GIT_AUTHOR_NAME=$( echo $author_line | cut -d " " -f2- )
export GIT_AUTHOR_EMAIL=$( echo $author_line | sed 's/ .*//' )


