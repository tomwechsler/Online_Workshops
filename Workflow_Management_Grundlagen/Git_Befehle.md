# Git Cheat Sheet

## GIT BASICS
Define the author name to be used for all commits by the current user.  

```
git config --global user.name "Tom Wechsler"
git config --global user.email "tom@example.com"
```

Create empty Git repo in specified directory. Run with no arguments to initialize the current directory as a git repository.  

```
git init <directory>
```

Clone repo located at "repo" onto local machine. Original repo can be located on the local filesystem or on a remote machine via HTTP or SSH.  

```
git clone <repo>
```

Stage all changes in "directory" for the next commit. Replace "directory" with a "file" to change a specific file or use a dot for all files in the repo.  

```
git add example.txt
or
git add .

```

Commit the staged snapshot, but instead of launching a text editor, use "message" as the commit message.  

```
git commit -m "New lines added to the script"
```

List which files are staged, unstaged, and untracked.  

```
git status
```

Display the entire commit history using the default format. For customization see additional options.  

```
git log

or

git log --oneline
```

Show unstaged changes between your index and working directory.  

```
git diff

or

git diff --cached
```

## UNDOING CHANGES
Create new commit that undoes all of the changes made in "commit", then apply it to the current branch.  

```
git revert <commit>
```

Remove "file" from the staging area, but leave the working directory unchanged. This unstages a file without overwriting any changes.  

```
git reset <file>
```

Shows which files would be removed from working directory. Use the -f flag in place of the -n flag to execute the clean.  

```
git clean -n
```

## REWRITING GIT HISTORY
Replace the last commit with the staged changes and last commit combined. Use with nothing staged to edit the last commit’s message.  

```
git commit --amend
```

Rebase the current branch onto "base". "base" can be a commit ID, branch name, a tag, or a relative reference to HEAD.  

```
git rebase <base>
```

Show a log of changes to the local repository’s HEAD. Add --relative-date flag to show date info or --all to show all refs.  

```
git reflog
```

## GIT BRANCHES

List all of the branches in your repo.  

```
git branch
```

Create and check out a new branch named bugfix. Drop the -b flag to checkout an existing branch.  

```
git checkout -b bugfix
```

Merge "branch" into the current branch.  

```
git merge bugfix
```