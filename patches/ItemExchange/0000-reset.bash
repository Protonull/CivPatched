#!/bin/bash
cd "$1" || exit 1

# Ensure remote upstream and checkout ignored
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

git commit --quiet -m "Reset ItemExchange"
git checkout --quiet -B patches ignored
