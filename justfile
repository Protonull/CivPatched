[private]
@default:
    just --list

# Builds all submodules, or a specific module if specified.
build module="":
    #!/bin/bash
    if [ -z "{{ module }}" ]; then
        echo "Building all submodules"
        ./gradlew clean reobfJar
    else
        echo "Building submodule: {{ module }}"
        ./gradlew clean :{{ module }}:reobfJar
    fi

# Reset all submodules to their init-state.
reset:
    #!/bin/bash
    git submodule status | awk '{ print $2 }' | while read submodule; do
        projectFolder=$(realpath --canonicalize-missing "$submodule")
        echo "Resetting $submodule"
        if ! (
            cd "$projectFolder"
            git rebase --quiet --abort 2>/dev/null
            git am --quiet --abort 2>/dev/null
            if [ -n "$(git status --short --porcelain)" ]; then
                git reset --quiet --hard HEAD
            fi
        ); then
            echo "Could not discard changes to $submodule"
            exit 1
        fi
        if ! (
            git restore --staged --worktree "$submodule"
            git submodule update --quiet --checkout --recursive --no-fetch "$submodule"
        ); then
            echo "Could not reset $submodule"
            exit 1
        fi
    done

# Fetches each submodule's upstream, printing how many commits behind they are.
fetch:
    #!/bin/bash
    git submodule status | awk '{ print $2 }' | while read submodule; do
        projectFolder=$(realpath --canonicalize-missing "$submodule")
        currentCommit=$(git rev-parse HEAD:"$submodule")
        echo "Fetching $submodule"
        if ! (
            cd "$projectFolder"
            git fetch --quiet
            upstreamCommit=$(git show-ref refs/remotes/origin/HEAD | awk '{ print $1 }')
            howFarBehind=$(git rev-list --count "$currentCommit..$upstreamCommit")
            if [ "$((howFarBehind))" -gt 0 ]; then
                echo " - is $howFarBehind commits behind!"
            fi
        ); then
            echo "Could not fetch $submodule"
        fi
    done

# Applies each submodule's respective patches.
applyPatches:
    #!/bin/bash
    git submodule status | awk '{ print $2 }' | while read submodule; do
        projectFolder=$(realpath --canonicalize-missing "$submodule")
        patchesFolder=$(realpath --canonicalize-missing "patches/$submodule")
        echo "Patching $submodule"
        if ! (
            cd "$projectFolder"
            git config core.eol lf
            git config core.autocrlf false
            git tag | xargs git tag -d >/dev/null
            git rebase --quiet --abort 2>/dev/null
            git am --quiet --abort 2>/dev/null
            if [ -n "$(git status --short --porcelain)" ]; then
                git reset --quiet --hard HEAD
            fi
        ); then
            echo "Could not reset $submodule"
            exit 1
        fi
        if ! (
            git -C "$projectFolder" checkout --quiet -B upstream "$(git rev-parse HEAD:"$submodule")"
            git -C "$projectFolder" checkout --quiet -B ignored upstream
        ); then
            echo "Could not setup upstream and ignored branches"
            exit 1
        fi
        resetScript="$patchesFolder/0000-reset.bash"
        if [ -f "$resetScript" ]; then
            # The reset script MUST create two branches: "ignored" and "patches"
            # The "ignored" branch is for any changes made within the reset script which shouldn't be turned into patches.
            # The "patches" branch on the other hand is for any changes that should be turned into patches.
            if ! (
                bash "$resetScript" "$projectFolder"
            ); then
                exit 1
            fi
        else
            echo "Could not find reset script for $submodule"
            exit 1
        fi
        if [ "$(find "$patchesFolder" -maxdepth 1 -type f -name "*.patch" | wc -l)" = "0" ]; then
            continue
        fi
        if ! (
            cd "$projectFolder"
            git am --reject --ignore-whitespace "$patchesFolder/"*.patch 2>/dev/null
        ); then
            echo "Could not apply patches to $submodule"
            exit 1
        fi
    done

# Generates patches for each submodule.
generatePatches:
    #!/bin/bash
    git submodule status | awk '{ print $2 }' | while read submodule; do
        projectFolder=$(realpath --canonicalize-missing "$submodule")
        patchesFolder=$(realpath --canonicalize-missing "patches/$submodule")
        echo "Generating patches for $submodule"
        if ! (
            cd "$projectFolder"
            git format-patch --no-signature --zero-commit --full-index --no-stat --no-numbered --output-directory "$patchesFolder" ignored
        ); then
            echo "Could not create patches for $submodule"
            exit 1
        fi
    done
