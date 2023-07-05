#!/bin/bash
cd "$1" || exit 1

git mv "paper/src" "src"
git rm -rfq "paper"
git commit --quiet -m "Flatten project structure"

git rm -rfq "gradle" "gradlew"
git commit --quiet -m "Remove Gradle wrapper"

git rm -rfq ".github" ".editorconfig" \
    "build.gradle.kts" "gradle.properties" "settings.gradle.kts" \
    "src/main/java/vg/civcraft/mc/civchat2/utility/CivChat2Executor.java"
git commit --quiet -m "Remove extraneous files"

git checkout --quiet -B patches ignored
