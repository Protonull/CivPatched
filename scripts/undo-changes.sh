#!/bin/bash

# Use this to un-commit all changes made to specific files in the current
# commit. This is useful while interactively rebasing when wanting to split a
# commit into two or more commits.

# If you use this by mistake, or otherwise have hunks/lines that you want to
# re-commit to the current commit, stage those changes and do:
# git commit --amend --no-edit

# Stuff that you want to split into a new commit, stage those changes and
# commit as normal. If you are interactively rebasing, it may say something
# scary like "[detached HEAD <HASH>]" but this is fine. Just continue your
# rebase as you would normally and the split-commit will appear in your git
# history where you'd expect.

filesToReset=("${@:1}")
for fileToReset in "${filesToReset[@]}"; do
    echo "Resetting $fileToReset"

    # Get the current content of the file.
    currentFileContent=$(git show "HEAD:$fileToReset")

    # Amend the comment to not have changed the file.
    git restore --quiet --source=HEAD~1 "$fileToReset"
    git add "$fileToReset"
    git commit --quiet --amend --no-edit --allow-empty

    # Ensure the folder is still there just in case the file was the only one
    # remaining in that folder and the folder was deleted.
    currentFileFolder=$(dirname "$fileToReset")
    if ! [ -d "$currentFileFolder" ]; then
        mkdir -p "$currentFileFolder"
    fi

    # Restore the content of the file.
    echo "$currentFileContent" > "$fileToReset"
done
