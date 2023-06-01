#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "6439102f9cd5ed59a039a704e239638ac3f18b39"
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

# Remove old classes
git rm -rfq "src/main/java/com/programmerdan/minecraft/simpleadminhacks/hacks/basic/EventDebugHack.java"

git commit --quiet -m "Reset SimpleAdminHacks"
git checkout --quiet -B patches ignored
