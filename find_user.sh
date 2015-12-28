#!/bin/bash

# copyright 2015 Edmundo Carmona Antoranz
# released under the terms of GPLv2

# svn authors file will be in environment variable SVN_AUTHORS

author_line=$( egrep '^'$GIT_AUTHOR_NAME' {0,}=' $SVN_AUTHORS )

if [ "$author_line" != "" ]; then
	# found the author... let's process it
	export GIT_AUTHOR_NAME="Test User"
	export GIT_AUTHOR_EMAIL="test@test.com"
fi

