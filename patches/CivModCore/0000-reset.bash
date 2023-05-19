#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "321ab959cfa72546551eb2600db6fa56e6bc742f"

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
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/maps"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/util"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/utilities/Title.java"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/world/WorldXZ.java"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/world/operations"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/nbt/storage"
git rm -rfq "src/main/java/vg/civcraft/mc/civmodcore/particles"

git commit --quiet -m "Reset CivModCore"
git checkout --quiet -B master upstream
