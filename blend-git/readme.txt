blend-git

Suppose you have a history like this:

A -> B -> C -> D -> E -> F -> G -> I
       \
        -> J -> K


Suppose that E and F had been created from a merge process of K with D but that,
for whatever reason, there is no relation to K as a parent. If that's the case
what should happen is that a new revision be created that has F's tree and D and
K as parents (call it F'). Then all revisions put on top of F should be reassembled 
on top of F'.

A -> B -> C -> D -> F' -> G' -> I'
       \          /
        -> J -> K 

The process can be thought of running something like this:

git rebase --onto F' F I

But performed automatically on _all_ branches that depend on F


This script uses 3 paremeters:

- REV1: last revision that will be KEPT
- REV2: last revision that will be REMOVED
- REV3: revision that will be used to replace segment REV1..REV2

