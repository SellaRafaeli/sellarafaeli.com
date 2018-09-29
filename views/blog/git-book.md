<!-- {"created_at": "2014-07-01"} -->
Hi there! This is the Best Git Book Ever. 

Welcome to Sella's Git Sandbox, aka The Best Git Book Ever. Find me at sella.rafaeli@gmail.com. 

We will cover the following topics:

1.  Command-Line Prompt
2.  Log
3.  Committing Changes
4.  Creating a new branch
5.  Comparing branches
6.  Finishing a Feature - Standard Flow
7.  Rebasing over Master
8.  Rebasing over Master - Going Deeper
9.  New Branch out of Existing Branch
10. Rebase Interactive
11. Rebase vs Merge: Why You shouldn't Merge From Master
12. Conflict Resolution
13. Conflict Resolution in the Terminal (Advanced)
14. Undoing an Uncommitted Change
15. Undoing a Commit 
16. Cherry-Picking
17. HEAD, Index, Working Directory
18. Stash
19. Default Text Editor
20. Aliases
21. SCM-Breeze
22. GUIs
23. Remotes: Introduction
24. Remotes: Inspection
25. Remotes: Tracking
26. Remotes: Pulling
27. Remotes: Ref-specs (advanced)
28. Remotes: Pushing
29. Remotes: Failed Pushes
30. Remotes: Diffing
31. Miscellaneous
32. Epilogue

## Introduction

We will learn some basic and advanced Git the slow and easy way using a renewable sandbox. You can make as many mistakes as you want and we'll clean them up and restart. This tutorial assumes you've already got Git setup, possibly with your organization's repository, and that you understand the basic concepts of version control.

The whole tutorial should take you about an hour or two, but you are encouraged to play around with the commands as much as you need to further your understanding. 

## Pre-Setup Tips for Unix nOobs

Some Unix-foo you should be familiar with before we start:

1. When I (or anyone) write "$ blah", they mean 'put the command "bla" on your command line'. The $ is a standard notation for 'your Unix command-line.' "#"s in this context are comments.
2. The command 'echo "foo" >> bar_file' appends the string 'foo' to the file bar, and is a quick shorthand way to edit files. 

## Setup
Run the following line in your terminal. 

  $ *curl https://raw.github.com/SellaRafaeli/bash/master/shell_scripts/git_sandbox >> ~/.sgsb1; source ~/.sgsb1; zz;*

This sets up a git 'sandbox' with several branches with files and commits with which you can play. 

Each branch has one or more files and commits (generally the files and commit messages will match the name of the branch). Assume your feature branch is 'foo' branch, and practice your standard (or exotic) git commands from it - diff from master, rebase over master, cherry-pick from branch bar, create a sub-branch, reset --soft and --hard, and so on. 

When you want to start over, run 'zz' again in your terminal, and the sandbox will be reset to scratch. This means you should NOT be afraid, and indeed you should hammer git as hard as you can until you understand what's going on.

The following lessons explain the important (and good) parts of Git. Before each lesson you should reset your sandbox to 'zz', and after each lesson you should make sure you understand how to execute the topic discussed. 

## Command-Line Prompt

Run:

    $ zz #refresh sandbox

By looking at your command-line you should be able to see at least: 

1. which directory you're in, 
2. which Git branch you are currently on ('master', by default),
3. Your current Git commit status (do you have non-committed changes).

Make osure your branch reflects all these. #1 and #2 should be immediately evident, and try switching branches to to verify number #3, make a change in some file and make sure you see the change in the command line (one common standard to denote a 'dirty' file is a '*' in the command-line. 

Practice:

    $ zz 
    $ git checkout foo #switch to foo branch
    $ echo "another line" >> foo_file #append another line to file named foo_file, make sure you see a 'dirty' state in the command line.

Links:

* http://www.neverstopbuilding.com/gitpro
* http://buddylindsey.com/adding-git-data-to-your-bash-prompt/
* http://conra.dk/2013/01/18/git-on-osx.html

## Git Log

As in every lesson, run 'zz' to start afresh.

Each 'branch' is a bunch of commits. 

On master branch, run 'git log' and see our list of commits. You can see each commit has some metadata (unique hash as id, author, date, and commit message). Each commit reflects some changes made to the project.

On master branch, run 'git log -p'. This shows you the verbose commit log - that is, the list of commits, and each commit's details: what exactly has changed in that commit. Notably, each commit has a 'hash' which is a unique identifier; in essence, it is the commit's ID. This ID is used whenever we want to perform an operation (including viewing) a specific commit.

The log is an incredibly important tool and you should make sure you feel comfortable with it. The are many ways to view the log. For example, try running:

    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

or

    git log --pretty=format:'\''%C(red)%h%C(yellow)%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'\'''

Those are much nicer ways of viewing the commit log. To make sure you can invoke it easily, set it up as a global terminal alias, or as a git alias. One easy way of doing it is running the following:

    git config --global alias.gl log --pretty=format:'\''%C(red)%h%C(yellow)%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'\'''

Now, whenever you run 'gl' (short for "git log") it will display the nice pretty log. You should be doing this *a lot* as you apply commits, to understand what's going on. Try to apply a couple commits and then reinspect the log and see that they've been added. Switch to another branch and reinspect the log, to see that on the other branch they are not present.

Practice:

    $ zz #reset sandbox
    $ gl #view master's log, notice commit messages regarding changes to master_file
    $ git checkout foo
    $ gl #view foo branch's log. Notice it only has part of master's commits, and then foo branch's commits.

Links:

* https://coderwall.com/p/euwpig
* http://garmoncheg.blogspot.co.il/2012/06/pretty-git-log.html

## Committing Changes
As in every lesson, run 'zz' to start afresh.

Using your text editor, open and change an existing file. Save it. You should see a 'dirty' state in the command line prompt. View 'git status' to see the changes Git has noticed, though they're "not staged for commit". Add the file to the 'staging' area using 'git add #name_of_file' (e.g., 'git add master_file'). 'git status' again to see the change now ready to be committed. Now commit the changes using 'git commit -m "some_message"', and view the log again to see your commit on top. 

Practice: 

    $ zz #reset sandbox
    $ # add a line to master_file
    $ git status #see file is changed but not staged for commit
    $ git add changed_file 
    $ git status #see file is ready for commit
    $ git commit -m "my staged & commited change" 
    $ gl #see your commit added to log
    $ git log -p #verbose log, see your change 

The 'staging' area is an intermediate step which you don't have to use. It adds complexity which is usually not needed and I advise not using it at all until you feel more comfortable with Git. So, let's repeat adding committing a change, this time without using the staging area. So, open your text editor and change a file. Back in terminal, 'git status' to see Git noticed the file you've changed, and now commit the file using 'git commit -am "some_other_message"'. The '-a' flag makes Git skip the 'staging' area, and you should basically always use it until you know better. View 'git log' again to see your changes on top.

Practice: 

    $ zz #reset sandbox
    $ # add a line to master_file
    $ git status #see file is changed but not staged for commit
    $ git commit -m "my direct commit" 
    $ gl #see your commit added to log
    $ git log -p #verbose log, see your change 

## New Branch
As in every lesson, run 'zz' to start afresh.

Let's create a new branch, add some commits, and inspect the log.
    $ git checkout master #make sure we start from master
    $ git checkout -b new_branch #notice we've switched to this branch
    $ gl #inspect log. Should be the same as before, since we've only created a new branch, have not added anything yet.
    $ git branch --list #see all existing branches. Notice 'new_branch' is there.
    $ git checkout new_branch #notice command-prompt should indicate you're in your branch.

Using your favorite text editor, add the line "hamster whiskey" master_file and commit it. View the log to make sure your changes have applied.
    
    $ git checkout new_branch
    $ #change master_file
    $ git commit -am "hamster whiskey" 
    $ gl #notice the new commit

If you've configured your git log to do so, you should see an indicator of where each branch's "HEAD" is. Our new branch should be one or more commits ahead of Master, for example. Make sure you see this in the log. 

Now, let's switch back to master (git checkout master) and inspect the log. It should be missing our branch's new commits, since they exist only in the branch, and not in master (yet).  

    $ git checkout master
    $ gl #no hamster whiskey

## Comparing Branches

As in every lesson, run 'zz' to start afresh.

The development normal flow is making changes on some feature branch and then adding your changes to the 'master' branch. Create a new branch, commit some changes and view the log to make sure they're there. Now, from the branch we're on, you can compare with Master by running 'git diff master'.

Practice:

    $ zz #refresh sandbox
    $ git checkout -b dog_branch
    $ # add the line "dog_line" to master_file and save it
    $ git commit -am "adding dog_line"
    $ gl #see the "dog_line" commit
    $ git diff master #notice the diff in dog_line

You will see a list of differences between your branch and master, per file. Each file changed will have red lines (what your changes have 'removed' from master) and green lines (what your changes have 'added'). You should be familiar with each and every change you will be adding to the 'master' branch, so you will be doing this comparison a lot. 

## Finishing a feature - Standard Flow
After you're done developing your feature, you will want to add your changes into 'master'. The general flow should be something like this:

1. Finish development of feature.
2. Checkout master branch and update it from remote origin (in case others have updated it in the meantime).
3. Now your master branch is updated. Go back to your feature branch and 'rebase' your feature branch over master, thus pulling master's latest changes into your branch. (More on this later.)
4. Now your master branch is updated, and your feature branch is based on the up-to-date master, and also has its own changes.
5. Compare your updated branch to master using 'git diff master' from your branch. You should see only the changes you introduced.
6. Look at your branch's log ('gl'). You should see your branch's commits on top of master's commits. 
7. Push your master branch. 

In the next few lessons we will practice these steps. 

## Rebasing over Master 

As in every lesson, run 'zz' to start afresh.

Suppose you're done with your changes on branch 'foo' and you want to update your branch with latest changes to master. In our sandbox, 'foo' has some changes to master, but is missing changes done after it branched off (just like you might be in real life, as other developers have been adding to master). 

    $ git checkout foo 
    $ gl #notice we have some commits done after branch off from master
    $ git diff master #notice we are also missing some commits from master
    $ git rebase master #git will grab master's new commits and reapply ours on top of them
    $ gl #notice our commit log now has all the commits
    $ git diff master #notice the only difference is now what we have that is not yet in master
    $ git checkout master 
    $ git merge foo #notice now master has all the changes done in foo as well

## Rebasing over Master: Going Deeper
As in every lesson, run 'zz' to start afresh.

Rebase is the first 'advanced' topic, that might differ from many naive Git tutorials. We will not teach you the simplest way to get things done, but the best way. It won't be hard. Keep swimming. Do it twice. 

As you recall - suppose you're on your feature branch and you've done making your changes. You are ready to add your changes to master branch. The correct flow is as follows:

1. Checkout master and pull its changes from remote server, so you have the updated master.
2. Checkout your branch, and *rebase* it over master. Solve conflicts if arise.
3. Diff with master to make sure you approve all changes you're about to add to master. 
4. Checkout master and *merge* in your branch. 
5. Push master to remote to share with everyone.

In this tutorial we do not have a remote server, but we have simulated that for you. Checkout 'foo' branch (git checkout foo) - assume on that branch you have added the 'foo' feature to the foo file. Diff with master -- notice that there are parts that we (foo branch) have which master doesn't have (displayed in +green), but there are parts which master has and we don't have (displayed in -red). This is because master branch has commits that were done after we checked out foo branch. 

In an organization, this is very standard; We checked out a branch and made some changes in our branch, but in the meantime other changes were added to master. So we have things master is missing, and master has things we are missing. We'll 'rebase' our branch over master by adding master's new commits to ours, by doing:

    $ git checkout foo #if we're not already in foo branch
    $ git rebase master 

'git rebase master' finds the point at which foo branched off of master, then applies all the commits done on master since, and then applies all of the current branch's (foo's) commits. The end result is that we have foo's commits on top of all of master's commits, which logically is exactly what we want - it's as if we had branched off of the most recent master and then applied all of our commits. 

Now our branch is updated with the most recent master, and we are satisfied with the diffs we want to add to master. So: 'git checkout master' followed by 'git merge foo'. 

This is a nuanced topic many (many!) Git users do not understand. I strongly recommend resetting the sandbox and performing the rebase again so you understand what's happening.

    $ zz #reset sandbox
    $ gl #notice master's commits
    $ git checkout foo
    $ gl #notice foo's new commits, but missing some of master's commits
    $ git diff master #notice we are missing some of master's changes
    $ git rebase master
    $ gl #notice foo's commits on top of ALL of master's commits
    $ git diff master #notice diff now includes only foo's new changes

Many naive tutorials suggest doing 'git merge master' instead of 'git rebase master'. Reset the sandbox and try it to see the difference - 'git merge master' will result in a git log containing a mixture of foo's and master's commits. The end result in the code will be the same, but inspecting the log will not show the correct chronological changes. 

For further information on why you should rebase over master (rather than merge) when you're done with your branch, see 

* "We Use Git Rebase, and So Should You" - https://medium.com/p/be89d1932a14/
* Git Rebase For Dummies - http://sellarafaeli.wordpress.com/2014/01/16/git-rebase-for-dummies/

## New branch out of existing branch. 
As in every lesson, run 'zz' to start afresh.

You can create branches out of any branch, not just out of 'master'. Checkout an existing branch (git checkout foo) and view the diff with master. Now create a sub-branch out of that branch (git checkout -b sub_foo), make some commit. View the log, and check the diff with the father branch (git diff foo) and then check the diff with mater (git diff master). Notice the predictable differences - sub_foo already has foo's commits, so they only show up when diff'ing with master (and do not show up when diff'ing sub_foo with foo). 

Practice:

    $ zz #refresh sandbox
    $ git checkout foo
    $ gl #notice we have foo's commits
    $ git checkout -b sub_foo
    $ # add the line "sub_foo" to foo file.
    $ git diff foo #only 'sub_foo' line is different
    $ git diff master #both sub_foo and foo lines are different

Why is this important? Suppose you are on branch 'foo' and want to rebase over master. Or revert, or reset -- or any other git command, and you're afraid you're going to fuck things up. And indeed, you might, but you shouldn't be afraid to experiment - it's the only way you're going to learn, after all. 

So you before rebasing branch 'foo' over master, for example, you might prefer to create your own branch 'sub_foo' (out of 'foo', so they're identical before you start rebasing). That way if things turn to shit, branch 'foo' is always there waiting for you. (There are also other ways of achieving the same ends such as pulling from remote, but we'll discuss that elsewhere.)

This is a good point to mention that 'master' is just a regular branch, which by default is the first and by convention the 'main' branch.  

## Rebase Interactive
Either right before or right after rebasing over master, you might want to collapse many commits into one or into a few. This is important in order to have a clean, relevant commit log. 

This great functionality is described in-depth here: 

* "Git Rebase -i Belong To Us" - https://medium.com/p/4d7010387683

(You should also have a git editor you are comfortable with. See below for further details).

Practice by:

* Performing a rebase-i on new branch 'bob' such that it only includes one single commit, then rebase the branch over master, then merge into master. Notice how master only has one single 'bob' commit added to it. 

Practice:

    $ zz # refresh sandbox    
    $ git checkout -b bob_branch 
    $ # create 4 commits, for example as follows:
    $ echo "bob one" >> master_file;
    $ git commit -am "bob first commit"
    $ echo "bob two" >> master_file;
    $ git commit -am "bob second commit"
    $ echo "bob three" >> master_file;
    $ git commit -am "bob third commit"
    $ echo "bob four" >> master_file;
    $ git commit -am "bob fourth commit"
    $ gl #see your 4 commits
    $ git rebase -i HEAD~4
    $ # change your multiple commits into one commit using the instructions in the link
    $ gl #see one commit for all of bob branch feature.
    $ git checkout master
    $ git merge bob_branch
    $ gl #see how new log has only added one commit to it

* Rebase an existing branch (foo) over master, then perform a rebase-i post the rebase, such that you remain with only one 'foo'-related commit, then merge into master. Notice how master only has one single 'foo' commit added to it. 

Practice: 

    $ zz #refresh sandbox
    $ gl #notice master has 8 commits
    $ git checkout foo 
    $ gl #notice foo branch has 4 commits of its own over 4 commits in master
    $ git rebase master
    $ gl #notice rebased foo branch now has its 4 commits over all of master's 8 commits
    $ git rebase -i HEAD~4
    $ # change your multiple commits into one commit using the instructions in the link
    $ gl #see one commit for all of bob branch feature.
    $ git checkout master
    $ git merge foo
    $ gl #see how new log has only added one commit to it

A clean commit log is easier to read, revert (if necessary), and cherry-pick into other branches (if necessary). For more on these, see below.

## Rebase vs Merge: Why You shouldn't merge
What many naive Git tutorials suggest is 'merging' instead of 'rebasing'. We will explain the difference in a nutshell, and then you will be able to see it yourself in the sandbox. 

Suppose you are on branch 'foo' and you want to add all of master's commits to your branch (which you should do before adding your branch back to master, see "Finishing a Feature", above). If you merge/rebase, Git finds the point where you 'branched off', and then applies all the commits since that point - from both the source branch (the one you are merging/rebasing) and the new branch. 

So, if we are in 'foo' and hit 'git merge/rebase master', Git finds where 'foo' branched off of 'master' and then reapplies all the commits from 'master' and from 'foo'. The difference is the *order* in which it will reapply them. 

If you 'rebase', the order will be first all the commits from master, then the commits from 'foo' (which is what you want -- your commits "on top" of everything else). 
If you merge, the order will be interspersed (mixed-up) -- it might be master-foo-master-foo. This is bad, because the resultant commit log will be a mix of master's and foo's, instead of foo-on-top-of-master, which, again, is what you logically want: your commits on top of master's. 

You can see this for yourself in the sandbox.

Practice Merging from Master (bad):

    $ zz #restart sandbox
    $ gl #notice master has 8 commits
    $ git checkout foo 
    $ gl #notice we have 4 of foo's commits, and 4 of master's commits
    $ git merge master
    $ gl #notice the commits are mixed-up: master's and foo's, interchangably. By just looking at the log, it is very hard to tell that we have just added 'foo' to 'master'.

Practice Rebasing over Master (good):

    $ zz #restart sandbox
    $ gl #notice master has 8 commits
    $ git checkout foo 
    $ gl #notice we have 4 of foo's commits, and 4 of master's commits
    $ git rebase master
    $ gl #notice the commits are in a good order: all of master's 8 commits, and above them we have foo's commits. Just by looking at the log, it is very easy to tell that we have just added 'foo' to 'master'. We can also rebase -i now (see above), further making our log cleaner and more agile. 

## Conflict resolution

This lesson is lengthy, but not difficult. 

When you 'rebase' or 'merge' you are applying commits from separate branches one on top of the other. Usually Git is smart enough to know how to deal with these, but occasionally you get a conflict - for example, if both branches edited the same line in the same file, Git won't know what to do. 

Let's practice by creating our own conflict. We will create a branch and set line number 9 to "Red", then set the same line in master to "Yellow", and then try to rebase.

    $ zz #reset sandbox
    $ git checkout -b conf_branch
    $ echo "Red Red Red" >> master_file 
    $ git commit -am "adding branch-is-red";
    $ git checkout master 
    $ echo "Yellow Yellow Yellow" >> master_file 
    $ git commit -am "adding master-is-yellow"

At this point you can inspect the master_file on both the conf_branch and on master_branch. Notice the difference where branch has 'Red' and master has 'yellow'. This simulates us finishing up the feature and adding 'red', while in the meantime someone has changed master_file and has added 'yellow'. Now let's rebase.

    $ git checkout conf_branch
    $ git rebase master

Oh no! Git has hit an issue while rebasing, since it does not know which line to use - Red or Yellow? We can see Git declare the issue:

    CONFLICT (content): Merge conflict in master_file
    Failed to merge in the changes.

Git also tells us what to do:

    When you have resolved this problem, run "git rebase --continue".
    If you prefer to skip this patch, run "git rebase --skip" instead.
    To check out the original branch and stop rebasing, run "git rebase --abort".

First (actually, last), we see that we can run 'git rebase --abort'. If this conflict scares you, run that -- it will abort the rebase, going back to the previous stage. 

Let's rebase again, and this time we'll solve the conflict. 

gco -b conf; echo "Red" >> master_file; gcam "red"; gco master; echo "yellow" >> master_file; gcam "yellow"; gco conf; git rebase master;
    $ git rebase master #prepare to beat the conflict
    
Observe the error message - specifically the line "Patch failed at": Git is telling you which commit it tried to apply which triggered the conflict. In our case it would be the commit adding "Red". So Git is in the middle of a commit applying "Red" which it is stuck. What status are we in, then, exactly?

    $ git status

We see the 'master_file' is under a status of 'both modified': both the branch and the source over which we are rebasing have modified it. Use 'git diff' to see the exact situation:

    $ git diff master_file

We will see something like:

    ++<<<<<<< HEAD
     +yellow
    ++=======
    + Red
    ++>>>>>>> red
    
This is Git's notation for conflicts:

* The <<<< signifies the start of the conflicting area. 
* The HEAD is the "previous commit" (in our case, master's top commit, since we're rebasing over it)
* Everything above the ==== is the version in the "previous commit" -- as in, everything that was added to the file by the commit currently being applied.
* Everything below the ==== is the version in our commit -- as in, what was added to the file by someone else (the branch we are rebasing over).

To resolve the conflict, we have three options: take 'their' version (ignore this commit), take our version (ignore 'theirs'), or merge them together manually. 

Practice: 

    $ zz #refresh the sandbox
    $ git checkout confl #a pre-made branch ready to be rebased with a conflict
    $ git rebase master 
    $ #solve the conflicts using master's texts, or your text, or both.
    $ git add master_file
    $ git rebase --continue

The manual way to resolve a conflict is to open the conflicting files in your text editor, go to the conflicting areas, and edit the text to whatever you *want* it to look like now. (Remember to remove the "<<"s, and eventually leave the file the way you want it). Now go back to the terminal, 'git add' the files you have edited, and commit them -- just like any other commit. Then tell Git to proceed with 'git rebase --continue'.

An alternative way of resolving conflicts, instead of using your text editor, is to use a "mergetool" - one of many lightweight GUIs to assist you in resolving the conflict. When you hit the conflits, run 'git mergetool', which will (after a prompt) launch a GUI tool to assist you in solving the conflict. When you're done, save and close the mergetool. 

## Conflict Resolution in the Terminal 

Practice: 

    $ zz #refresh sandbox
    $ git checkout confl #pre-made branch ready to be rebased with conflict
    $ git rebase master #hit error
    $ git status #see which file has the conflict: master_file
    $ git diff master_file #view the conflict and both versions
    $ git checkout --theirs master_file #take 'theirs'
or
    $ git checkout --ours master_file #take 'ours'

At this point you can inspect the file and see that indeed you have taken the correct version.

    $ git diff master_file #either no change (ours) or some change (theirs)
    $ git add master_file
    $ git rebase --continue

When git-rebasing, 'our' version (yellow) is the one in the branch we are rebasing over (usually 'master'), and 'theirs' is the version from the feature_branch. So if we are in 'conf' branch and doing a git rebase master, 'ours' is the master version and 'theirs' is the branch version. 
(If this seems backwards, imagine it is because the first thing rebase does is checkout the rebased version, and then reapply the branch commits on top of it.)

When merging, it is the opposite: 'our' version is the branch we are on, and 'theirs' is the branch we are merging in.

 one from master, when rebasing over master) and 'theirs' is the one we are re-applying (red). 

Links: 

* http://gitready.com/advanced/2009/02/25/keep-either-file-in-merge-conflicts.html
* https://rtcamp.com/tutorials/git/git-resolve-merge-conflicts/
* http://stackoverflow.com/questions/2959443/why-is-the-meaning-of-ours-and-theirs-reversed-with-git-svn (best link)

## Undoing a Non-committed Change: Git Checkout

If you've made uncommited changes in your working directory, you can undo them by running "git checkout", either on a single file or a directory. 

Practice: 

    $ zz #reset sandbox
    $ echo "another line" >> master_file 
    $ git status #file has changed
    $ git checkout master_file
    $ git status #file is back to previous 

Behind the scenes: To understand why this works, in brief, Git keeps track of three things: the 'last commit' (referred to as HEAD), the 'next commit' (referred to as the Index or the Staging area, and I recommend not using it), and the working directory (your filesystem). Basically, 'git checkout' takes the HEAD of a file (or files) or a branch and sets it into your working directory. (And yes, this is also what 'git checkout some_branch' works).

## Undoing a Committed change: Git Reset

If you've made changes and committed them, you can still undo them, as long as you haven't pushed. (If you've pushed them to a remote you can *still* undo them, but other people might have already pulled those changes, which will cause much confusion, so don't).

The way to undo commits is with "git reset", by resetting to the last good commit you had. View the log, then 'reset' back to the last good commit's hash. After resetting, the "removed" commits 

Practice:
    
    $ zz #reset sandbox    
    # add 4 commits to master_file: 
    # add "venus_1" to master_file and commit it under the message "venus_1"
    # add "venus_2" to master_file and commit it under the message "venus_2"
    # add "venus_3" to master_file and commit it under the message "venus_3"
    # add "venus_4" to master_file and commit it under the message "venus_4"
    # as a short-hand for the above, run the following line:
    $ for var in {1..4}; do echo "venus_#$var" >> master_file; git commit -am "venus_$var"; done;
    $ gl #see the log contains 4 'venus' commits
    # copy the commit hash of the first venus commit (in my case, it's c9b6641)
    $ git reset c9b6641
    # now the commits of venus_1, venus_2, and venus_3 have been removed from the commit log. 
    # The changes that were in those commits appear as uncommited changes in the working dir.
    $ git status #see master_file now has uncommited changes
    $ git diff master_file #see the reset changes appear as uncommited changes.
    # you can now edit the reset changes and recommit them, or cancel them by running 'git checkout master_file' (see above).

When running 'git reset [commit-hash]', all commits above that hash are removed, and the changes they included appear as uncommited changes in your working directory. 

If you add the flag '--hard' (git reset --hard [commit-hash]) then the changes will be forcefully removed (will not appear in your working directory). 
If instead you add the flag --soft (git reset --soft [commit-hash]), then the changes will appear in your working directory, and will have already been added to your staging area.

I recommend not using the soft/hard flags as they are confusing/dangerous. Do a simple 'git reset' and then deal with the reset changes in your working directory as you wish.

Links:

* "Git reset, not so --hard after all" - https://medium.com/p/e3de88bb66a5 (recommended reading!)

## Cherry-Picking: 

Sometimes you don't want to rebase/merge in another whole branch, but you just want to grab a single commit from that branch. You can do that by 'cherry-picking' that commit hash into wherever you want to apply it, so that you can apply a single commit from branch 'bar' to branch 'foo'.

Practice:

    $ zz #reset sandbox
    $ git checkout bar 
    $ gl #copy the first 'bar' commit hash. In my case it is a82d14d, and it is the commit adding the file 'bar'.
    $ git checkout foo 
    $ git cherry-pick a82d14d
    $ ls #see we have added the file 'bar'
    $ gl #notice we have a new commit (latest) adding the file bar.

As a side note, in some cases (such as if you take a commit changing to a file you do not yet have) you will run into a cherry-picking conflict, which should be resolved just like any other conflict. In the case of a missing file, make sure to 'add' it to resolve the conflict. 

## HEAD, Index, Working Directory

As you learn more and more about Git, you learn the terminology as well. Here are some approximations to help you understand Git literature and workings:

* HEAD is your last commit. Each branch has is a list of commits, and the last commit of the current working branch is called HEAD. Naturally this means HEAD changes whenever you change branchs.
* Index is your "next" commit, also called the 'staging area'. You can 'stage' changes, bringing them into the Index/Staging area, thus creating a list of changes that will be commited once you run 'git commit'. If you add the -a flag to committing ('git commit -a') then *all* changes (in tracked files) will be committed, not only the ones in staging. For simplicity, I recommend NOT using the staging area or Index at all until you are experienced with Git, and to always commit all changes. 
* Working Directory is the files on your disk. These files exist outside of Git as well, and you can access them in any way you please, from any editor or terminal. Any time you switch branches, Git modifies your working directory to reflect the contents of that branch. 

Practice:

    $ zz #refresh sandbox
    $ gl #view log. Notice HEAD is the last commit on master.
    $ ls #note no file called 'maz_file' exists in directory.
    $ git checkout maz #switch to maz branch, which is 'ahead' of master.
    $ gl #notice HEAD is the now the last commit on 'maz' branch. Note your log should also show you which commit 'master' branch is on. 
    $ ls #note Git has updated working directory to include 'maz' file. 

## Git Stash 

Git won't let you swap between branches when you have uncommitted code. It encourages you to either commit your code or 'stash it' into a stack of changes Git manages. You can read more about git stash online, but the simplest use case is temporarily 'stashing' your changes, switching branches, then 'popping' (re-applying) the changes the other branch (if so desired).

Practice:

    $ zz #refresh sandbox
    $ echo "test" >> master_file #add line to master file. Notice Git shows 'dirty' state.
    $ git checkout maz #Git won't allow, tells us to commit or stash changes.
    $ git stash #Note uncommited changes have been undone
    $ git stash show #see the changes waiting for you in the stash
    $ git checkout maz #now Git will allow you to switch 
    $ git stash show #see the same changes -- stash is global, not under a specific branch.
    $ git stash apply #reapply the changes, if you want to. 

## Default Text Editor
    
Occasionally Git opens up text editors for you - to edit commit messages, rebase -i handling, and so on. The default text editor differs; often it is Vim or some other basic text editor. If you feel uncomfortable with Git's default text editor, you can tell it to use a different one. This is set in Git's config file, which by default resides at ~/.gitconfig. Open up that file with your favorite text editor, and add/modify the [core] section to include an 'editor' as such: 

    editor = subl -n -w

In this case we have used SublimeText, but you can use whatever application you want -- just make sure the line defined by 'editor = ' runs that text editor when you run it in your terminal. (You may have to preconfigure aliases or system path.)

Now, whenever Git needs to open a text editor, you will get you comfrotable text editor rather than Git's default one. 

Practice:
    
    $ zz #refresh the sandbox
    $ echo "read me in default text editor!" >> master_file
    $ git commit -a #note no "-m", so Git will default text editor for the commit message.
    # setup your text editor in Git config file.
    $ zz #refresh the sandbox
    $ echo "read me in your favorite text editor!" >> master_file
    $ git commit -a #note no "-m", so Git will open your configured text editor for the commit message.
                    #write commit message in your favorite text editor. 

Note, the Git config file has many options and goodies you can preconfigure to enhance your use.

Links: 

* https://help.github.com/articles/associating-text-editors-with-git

## Aliases 

Unix systems terminals allow you to create aliases for common operations. Instead of writing 'git checkout' a million times, we will create an alias for that: 'gco'. Aliases can be defined in various places; the default place is your 'bash_profile', which is loaded every time you open a new terminal. 

Practice:

    $ #open ~/.bash_profile in your text editor
    $  #add the following as the first line of the file: alias gco='git checkout'
    $  #save the file and open a new terminal
    $ zz #reset the sandbox
    $ gco foo #alias for git checkout foo
    $ #notice switch to branch foo

You can thus speed up your Git experience by creating aliases for your common operations. My favorites are:

* 'gco' for 'git checkout'
* 'gs' for 'git status'
* 'gd' for 'git diff'
* 'gcam' for 'git commit -am'

## SCM-Breeze

Now that you know about aliases, you can reasonably assume that others have already done it before you. You can use their packages for robust functionality. One such recommended package is SCM-Breeze. Check it out in the link below -- it will supply you with many useful aliases, as well as a shorthand method of referencing files displayed in the 'git status'. I heavily recommend using this (or other) such packages. 

Practice:

    1. Install SCM-Breeze
    2. run 'zz' to refresh sandbox
    3. Use the above shortcuts 

Practice: 
    
    $ #install scm-breeze
    $ zz #refresh sandbox
    $ echo "change" >> master_file
    $ gs #see [1] master_file
    $ gd 1 #shorthand for 'git diff [file 1]'

Links: 

* https://github.com/ndbroadbent/scm_breeze

## A word about GUIs

While we have been focusing on Git terminal usage, Git also has many, many GUIs. Many IDEs include their own flavor of a Git GUI. While this is a classic software "Holy War" (command-line vs GUI), I would recommend trying out both: GUIs often offer functionality which is difficult to replicate in command-line ("History of Selection" comes to mind), but my experience is that you only really understand what the hell you're doing if and only if you are doing it in the command line. 

As a footnote, Git often comes bundled with various GUI utils such as "gitk" or "git instaweb --httpd webrick" which give you various GUI abilities. Figure out what's best for you.

## Remotes: Introduction

The rest of this document will deal with 'remotes'. This document does not currently include a tutorial to work with remotes, but you can set up a repository under your own user in github.com and practice with it. The following will simply be a list of issues you should be familiar with.

Assuming your repository has a remote configured, you can view the remote by running:

    $ git remote -v

This will display the repository with which you are working. You should see two options: one for pulling (actually 'fetching', which is almost the same, as we'll discuss later) and one for pushing. Presumably they would be the same one.

Working with remotes is important. Most commonly your 'remote' will be github.com or some other similar site (in this document, we will assume it is github). Your remote will also hold copies of many branches, and in general each local branch will have its counterpart in the remote. 

So, your local branch may exist only locally, as is covered above. If you want to share your branch with others, you will probably want to put it on the 'remote' Git server. 

## Remotes: inspecting

You can go into github.com and view all the branches in your repository. (If your company has more than one codebase, your will have more than one repository, and you can browse each one separately.)

In each branch, you can see each file. You can inspect the contents of each file in each branch (in fact, you can even edit directly in github.com). 

In each branch, You can see the list of commits in the project -- this is the same commit log on your computer. If all participants keep the commit log clean - use 'rebase' & rebase -i' to ensure they only add minimal, clensed commits - you can easily track the list of features and changes made to the codebase. 

Practice: 

    1. Open your main repository in github.com on 'master' branch
    2. View the commit log. 
    3. Compare it to your local commit log on same branch ($ gl)

You can also browse individual files and their history. 

Practice: 

    1. Open your main repository in github.com on 'master' branch
    2. Open a specific file you are familiar with
    3. View its commit log 

## Remotes: tracking

Each local branch can 'track' one remote branch. 

    $ git branch -vv #shows you which local branch tracks which remote branch. 

However, do not naively assume that 'git push' and 'git pull' will push or pull from the branch you are tracking. It's a bit more complicated than that -- but we will try to implement a simple workflow, so you don't have to remember all these. 
    
    $ git remote show origin #shows you all local and remote branches as well as tracking info, and which branch pulls from/pushes to which remote branch. 

There are many options to use this, but you should keep things simple: each local branch should either track no remote branch or track the remote branch with the same name. You can tell a local branch 'foo' to track a remote branch by name of 'foo' by running:

    $ git checkout foo #enter 'foo' branch'
    $ git branch --set-upstream-to foo #might show a warning if this is already the case. Now 'foo' tracks 'foo'.

You can use the above to understand how to make one branch track another with a different name, but I advise against it until you feel very comfortable with Git remotes. 

You can also set the 'upstream' branch when pushing, by running:

    $ git checkout foo #enter foo branch
    $ #make some changes..
    $ git push -u origin foo #push to foo, and set upstream tracked branch to foo.

## Remotes: pulling

Running 'git pull' will pull the changes from the server into your branch. The basic flow you would have for updating a branch would be:

    $ git checkout my_branch
    $ git pull #or git pull origin my_branch. This branch now has merged the changes on the remote.

Some things you should know:

    1. git pull == fetch + merge

By default, when you 'git pull' into a branch, you are *merging* the pulled new commits into your local branch. In some cases (like if you are committing directly to master), this is less than ideal, since when you push you will want your commits to be on top. In those cases run 'git pull --rebase' to do a fetch+rebase. You can also set pull to rebase by default; see links below.

    2. git pull origin some_branch 

By default if you run 'git pull' it will pull the upstream branch (which should be the branch of the same name). You can explicitly pull any remote branch into your local branch:

    $ git checkout foo
    $ git pull origin bar

I would advise against doing this. You should use either the simple 'git pull' or 'git pull origin foo' when in branch foo. If you need to integrate changes from one branch into another, pull them both separately and do all the merging locally. 

Links:

* http://stevenharman.net/git-pull-with-automatic-rebase
* https://coderwall.com/p/yf5-0w

## Remotes: ref-specs (Advanced)

Actually, when you 'git pull' git updates information about all of the remote branches -- but it only performs the merge on the branch you are currently in. Thus, other branches are not updated, but information about them in the remote is updated. 

You can see this in Git's output after running 'git pull' (it shows you the list of branches for which it has updated the information).

Git stores the 'remote' version of each branch in a separate location, denoted by 'origin/'. As in, you can compare your local branch 'bar' with remote 'bar' by running:

    $ git checkout master 
    $ git pull #local master is merged with remote master, other branches are not merged but our local git now has information about the remote branches
    $ git checkout bar #bar has not been merged with its remote
    $ git diff origin/bar # diff with remote bar
    $ git diff origin/foo # diff with remote foo

Remember, git diff with origin/ won't always be the diff with the 'remote': it is only the diff with the local data *about* the remote, which is obtained when running 'git pull'.
    
## Remotes: pushing

Running 'git push' will push your branch into the server. The basic flow you would have for updating a remote branch would be:

    $ git checkout foo
    $ git push #or git push origin foo. Remote branch foo will now have your code. 

Some things you should know:

    1. 'git push origin foo' pushes your local branch foo to remote branch foo. 

    2. You can use the shorthand 'git push' instead. When you do not name a branch, git's "default" push behavior is defined in gitconfig. 

    In short, you should use 'current' ($ git config --global push.default current). 'Upstream', 'tracking' (deprecated) and 'simple' will also do. 
    
    3. Remember 'git push' replaces the *entire* remote branch with your local branch - you are effectively replacing everything that is there. 

    *. Advanced: 'git push origin foo' is shorthand git push origin foo:foo, which means pushing your local branch foo to remote branch foo. If you want to push local branch foo to remote branch bar, run git push origin foo:bar. 

Links: 

* http://blog.santosvelasco.com/2012/07/15/make-git-push-the-current-branch-by-default/
* http://www.lorrin.org/blog/2011/10/03/argumentless-git-pull-and-git-push/comment-page-1/
* http://stackoverflow.com/questions/948354/git-push-default-behavior #best link

## Remotes: failing pushes

Sometimes when you try to push Git refuses to accept the push. This can be because Git does not know what the upstream branch is (or perhaps it does not exist yet in the remote) - in this case you can push with setting upstream by running:
    
    $ git push --set-upstream origin foo 

or

    $ git push -u origin foo

Both of which set the upstream to foo and then push to foo. 

Other times, Git may refuse to allow you to push, because the remote has changes you do not have (yet). This may happen when collaborating on a branch with someone, and Git is protecting you - it is saying "do not push yet, things have changed". 

In such a case, you can update your local branch with the remote (git pull), resolve any conflicts, and then push. 

An alternative is to push with --force ($ git push --force), which predictably forces your push despite Git's warnings. This *destroys* anything in the server that you did not have, since you are replaced the remote contents with your own. If you are working on a solitary branch this is fine (since you would be replacing your own code with your own code); if working on a shared branch this means you might be demolishing some else's code, so be wary.

## Remotes: diffing

After running 'git pull', Git stores a local version of the contents of each remote branch.  You can diff your local branches vs these branches as follows:

    $ git checkout foo 
    $ git pull #Git now knows what all remote branches look like. In addition, it merges local foo with remote foo.
    $ git diff origin/foo #Will be empty, since we just merged foo with its remote.
    $ git diff origin/master #Will show diff with remote master. 

## Miscellaneous

    $ git --version #self-explanatory
    $ git config --list #see all config values, both set in your .gitconfig file and inherited

## Epilogue

Git can be a human factors horror show, and yet every developer is expected to use it inside and out, and your usage may affect your teammates, so you can't even just white-knuckle it. 

I hope you have found this book helpful. 

For any issue please contact sella.rafaeli@gmail.com. 
(this file is available at https://www.dropbox.com/s/vk8wr4843qrzp6j/git_sandbox.md)

This is version 23.3.14.1615