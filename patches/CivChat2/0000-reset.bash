#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "6d3c5f2952cdd2f8b4a11d7a278b07f5f0e5ae6c"
git branch --quiet --set-upstream-to=origin/master upstream
git checkout --quiet -B ignored upstream

# Relocate Java src to root of submodule
git mv "paper/src" "src"
git rm -rfq "paper"

# Remove submodule's Gradle wrapper and files
git rm -rfq "gradle" "gradlew" "gradle.properties" "settings.gradle.kts"

# Remove .editorconfig
git rm -rfq ".editorconfig"

# Remove Github workflows
git rm -rfq  ".github"

git commit --quiet -m "Reset CivChat2"
git checkout --quiet -B patches ignored
