# Git Cheat Sheet

## GIT BASICS
Define author name to be used for all commits in current repo. Devs commonly use --global flag to set config options for current user.  

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
```