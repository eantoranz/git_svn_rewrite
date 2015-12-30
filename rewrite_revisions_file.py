#!/usr/bin/python

# copyright 2015 Edmundo Carmona Antoranz
# released under the terms of GPLv2

import sys
import os
import binascii
import struct

def readRevisions():
    revisionsFile = open(os.environ['SVN_REVISION_FILE'], 'ro')
    revisions = dict()
    while True:
        line = revisionsFile.readline()
        if len(line) == 0:
            # EOF
            break

        parts = line.strip().split(' ')
        if len(parts) <> 2:
            # don't have the right amount of values on the line
            continue

        revisions[parts[0]] = parts[1]
    # done
    revisionsFile.close()

    # add 'null' revision
    if '0000000000000000000000000000000000000000' not in revisions:
        revisions['0000000000000000000000000000000000000000'] = '0000000000000000000000000000000000000000'

    return revisions

def parseByte(aByte):
   None 

def processRevisionsFile(fileName, revisionsMap):
    newMapping = dict() # mapping number of ID to new Revision
    revisionsFile=open(fileName, 'ro')
    eof = False
    missingRevisions = False # we assume all revisions are found
    while True:
        # every item in the file has the binary ID of the binary (4 bytes) then the 160 bytes of the sha1 of the revision
        revisionNumber = 0
        for i in range(0, 4):
            aByte = revisionsFile.read(1)
            if len(aByte) == 0:
                # reached EOF
                eof = True
                break
            revisionNumber = revisionNumber * 256 + ord(aByte)
        # now let's capture the ID of the revision
        revisionId = "" 
        for i in range(0, 20):
            aByte = revisionsFile.read(1)
            if len(aByte) == 0:
                # reached EOF
                eof = True
                break
            revisionId += aByte

        if eof:
            # finished with the file
            break

        revisionId = binascii.hexlify(revisionId)
        # the revision has to be in the map
        if revisionId not in revisionsMap:
            sys.stderr.write("Revision " + str(revisionNumber) + " doesn't have a mapped revision (" + revisionId + ")\n")
            missingRevisions = True
        else:
            newMapping[revisionNumber] = revisionsMap[revisionId]

    # done with the file
    revisionsFile.close()

    if not missingRevisions:
        revisionsFile = open(fileName, 'w')
        for revisionNumber in sorted(newMapping.keys()):
            revisionsFile.write(struct.pack('>I', revisionNumber))
            revisionsFile.write(binascii.unhexlify(newMapping[revisionNumber]))
        revisionsFile.close()
    else:
        sys.stderr.write("Won't rewrite file " + fileName + " because of missing revisions\n")

revisionsMap=readRevisions()

for i in range(1, len(sys.argv)):
    processRevisionsFile(sys.argv[i], revisionsMap)
