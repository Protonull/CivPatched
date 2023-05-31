#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "727b8cb2d534a57aeea63e4b5d14081b6aba6589"
git branch --quiet --set-upstream-to=origin/master upstream
git checkout --quiet -B ignored upstream

# Relocate Java src to root of submodule
git mv "paper/src" "src"
git rm -rfq "paper"

# Remove submodule's Gradle wrapper and files
git rm -rfq "gradle" "gradlew" "gradlew.bat" "gradle.properties" "settings.gradle.kts"

# Remove .editorconfig
git rm -rfq ".editorconfig"

# Remove Github workflows
git rm -rfq  ".github"

git commit --quiet -m "Reset JukeAlert"
git checkout --quiet -B patches ignored
