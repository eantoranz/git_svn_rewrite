GIT SVN REWRITE TOOL



INTRO
This module is used to rewrite git-svn's history

It all started with me discovering the possibility to use an authors file
that could be used to map user IDs as used on svn with real people's names
and mail addresses, the way it is used on git. But it was already too late
for the revisions I already had on my repo.

I tried to rebuild the history of the project (again) but failed for...
doesn't matter, does it?

So I decided to create something that could hack git-svn's metadata
after having "rewriten" the history of the branches (with filter-branch).



REQUIREMENTS
I think only two things are needed:
- Bash
- Python



SET UP
Two environment variables have to be set up:
SVN_AUTHORS - path to git-svn's authors file
SVN_REVISION_FILE - path for the file where the mapping between old and new revision IDs will be held

The process to rewrite the history of the project consists of two steps:

- use git-filter-branch to rewrite the history of the project.
  Ex: git filter-branch --commit-filter '/path/to/git_svn_rewrite/remap_ids.sh "$@"' -- --all

- rewrite git-svn's revision mapping files:
  Ex: find .git -iname '.rev_map*' -exec /path/to/git_svn_rewrite/rewrite_revisions_file.py {} ';'

That should be enough to be able to rewrite the whole history of the project (but I will test it for
real tomorrow so don't expect it to work just because I say so now... v0.1, see?).

Cheers!

Edmundo Carmona Antoranz
Dec 2015 
Heredia, Costa Rica
