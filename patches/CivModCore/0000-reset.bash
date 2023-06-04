#!/bin/bash
cd "$1" || exit 1

# Checkout the submodule upstream commit
git checkout --quiet -B upstream "321ab959cfa72546551eb2600db6fa56e6bc742f"
git branch --quiet --set-upstream-to=origin/master upstream
git checkout --quiet -B ignored upstream

git mv "paper/src" "src"
git rm -rfq "paper"
git commit --quiet -m "Flatten project structure"

git rm -rfq "gradle" "gradlew" "gradlew.bat"
git commit --quiet -m "Remove Gradle wrapper"

git rm -rfq ".github" ".editorconfig" "gradle.properties" "settings.gradle.kts"
git commit --quiet -m "Remove extraneous boilerplate"

# Remove old classes
git rm -rfq \
    "src/main/java/vg/civcraft/mc/civmodcore/maps" \
    "src/main/java/vg/civcraft/mc/civmodcore/util" \
    "src/main/java/vg/civcraft/mc/civmodcore/utilities/Title.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/world/WorldXZ.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/world/operations" \
    "src/main/java/vg/civcraft/mc/civmodcore/nbt/storage" \
    "src/main/java/vg/civcraft/mc/civmodcore/particles" \
    "src/main/java/vg/civcraft/mc/civmodcore/players/settings/impl/AltConsistentSetting.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/players/settings/AltRequestEvent.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/players/settings/gui/ClickableMenuItem.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/events/CustomEventMapper.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/events/PlayerMoveBlockEvent.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/inventory/items/ItemBuilder.java" \
    "src/main/java/vg/civcraft/mc/civmodcore/inventory/items/ItemFactory.java"
git commit --quiet -m "Remove extraneous code"

git checkout --quiet -B patches ignored
