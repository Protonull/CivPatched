#!/bin/bash
cd "$1" || exit 1

git mv "paper/src" "src"
git rm -rfq "paper"
git commit --quiet -m "Flatten project structure"

git rm -rfq "gradle" "gradlew" "gradlew.bat"
git commit --quiet -m "Remove Gradle wrapper"

git rm -rfq ".github" ".editorconfig" \
    "build.gradle.kts" "gradle.properties" "settings.gradle.kts" \
    "src/test/resources/config.yml" \
    "src/main/java/com/programmerdan/minecraft/simpleadminhacks/hacks/basic/EventDebugHack.java"
git commit --quiet -m "Remove extraneous files"

git checkout --quiet -B patches ignored
