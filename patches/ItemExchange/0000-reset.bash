#!/bin/bash
cd "$1" || exit 1

git mv "paper/src" "src"
git rm -rfq "paper"
git commit --quiet -m "Flatten project structure"

git rm -rfq "gradle" "gradlew" "gradlew.bat"
git commit --quiet -m "Remove Gradle wrapper"

git rm -rfq ".github" ".editorconfig" "gradle.properties" "settings.gradle.kts"
git commit --quiet -m "Remove extraneous boilerplate"

git checkout --quiet -B patches ignored
