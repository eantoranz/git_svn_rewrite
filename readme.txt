GIT SVN REWRITE TOOL



INTRO
This module is used to rewrite git-svn's history

It all started with me discovering the possibility to use an authors file
that could be used to map user IDs as used on svn with real people's names
and mail addresses, the way it is used on git. But it was already too late
for the revisions I already had on my repo.

I tried to rebuild the history of the project from scratch (again) but
failed with some sort of sigseg so, after many attempts, I just gave up.

So I decided to create something that could hack git-svn's metadata
after having "rewritten" the history of the branches (with filter-branch)
so that I got the real names of people of commits that had svn's user IDs.


REQUIREMENTS
I think only two things are needed:
- Bash
- Python (I tested with 2.7 and 3.0)


SET UP
- Two environment variables have to be EXPORTed:
SVN_AUTHORS - path to git-svn's authors file
SVN_REVISION_FILE - path for the file where the mapping between old and new revision IDs will be held

- Also, do this process on a _copy_ of your repo just in case.


REWRITE PROCESS

The process to rewrite the history of the project consists of two steps:

- use git-filter-branch to rewrite the history of the project.
  Ex: git filter-branch --commit-filter '/path/to/git_svn_rewrite/remap_ids.sh "$@"' -- --all

- rewrite git-svn's revision mapping files:
  Ex: find .git -iname '.rev_map*' -exec /path/to/git_svn_rewrite/rewrite_revisions_file.py {} ';'

Both variables have to be set up for both parts of the process.


BOTTOMLINE

I was successful rewriting the history on a repository with plenty of branches and plenty
of revisions. After the rewrite process was done (both steps) I was able to continue working as
usual with fetch/dcommit (I particularly don't do other fancy stuff with git-svn, be warned).


Cheers!

Edmundo Carmona Antoranz
Jan 2016 
Heredia, Costa Rica

