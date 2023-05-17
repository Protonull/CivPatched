#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "e064ccae7bfb2827ca8ebe2447505c41f406ad2b"

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
git checkout --quiet -B master upstream
