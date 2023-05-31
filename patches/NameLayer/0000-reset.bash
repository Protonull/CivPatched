#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "921c15df934d36d6c4a9519d47e615ebd83fde2f"
git branch --quiet --set-upstream-to=origin/master upstream
git checkout --quiet -B ignored upstream

# Relocate Java src to root of submodule
git mv "paper/src" "src"
git rm -rfq "paper"

# Remove submodule's Gradle wrapper and files
git rm -rfq "gradle" "gradlew" "gradlew.bat" "gradle.properties" "settings.gradle.kts"

# Remove unused modules
git rm -rfq "nms" "namelayer-bungee"

# Remove .editorconfig
git rm -rfq ".editorconfig"

# Remove Github workflows
git rm -rfq  ".github"

git commit --quiet -m "Reset NameLayer"
git checkout --quiet -B patches ignored
