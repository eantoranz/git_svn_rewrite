#!/usr/bin/python

import sys

def defaultValues():
    print "test@testdomain.com Test User"

# will only read a single line of input (if at all)
line = sys.stdin.readline()

if len(line) == 0:
    # there was no input line
    defaultValues()
    sys.exit(0)

# we get rid of the information up to '='

temp = line.split('=', 2)
if len(temp) < 2:
    # not what we were expecting to see
    defaultValues()
    sys.exit(0)

# there has to be a name and a mail at the end
temp = temp[1].strip().split()
if len(temp) < 2:
    # don't have enough values
    defaultValues()
    sys.exit(0)

# email has to have <> surrounding it
email = temp[-1].lstrip('<').rstrip('>')

name = ""
for i in range(0, len(temp) - 1):
    namePart = temp[i]
    if i > 0:
        name += ' '
    name += namePart

print email + " " + name 
