pluginManagement {
    repositories {
        gradlePluginPortal()
        maven("https://repo.civmc.net/repository/maven-public/")
        maven("https://papermc.io/repo/repository/maven-public/")
    }
}

rootProject.name = "CivPatched"

include(":CivModCore")
