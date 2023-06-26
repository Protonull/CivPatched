plugins {
    id("java-library")
    id("net.civmc.civgradle") version "2.+" apply false
    // https://github.com/PaperMC/paperweight/tags
    id("io.papermc.paperweight.userdev") version "1.5.5"
    // https://github.com/johnrengelman/shadow/releases
    id("com.github.johnrengelman.shadow") version "7.1.2"
    // https://kotlinlang.org/docs/home.html
    kotlin("jvm") version "1.8.22"
}

dependencies {
    paperweight.paperDevBundle(rootProject.libs.versions.minecraft)
}

subprojects {
    apply(plugin = "java-library")
    apply(plugin = "net.civmc.civgradle")
    apply(plugin = "io.papermc.paperweight.userdev")
    apply(plugin = "com.github.johnrengelman.shadow")
    apply(plugin = "kotlin")

    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(17))
        }
    }

    configure<org.jetbrains.kotlin.gradle.dsl.KotlinProjectExtension> {
        jvmToolchain(17)
    }

    tasks {
        build {
            dependsOn(shadowJar)
            dependsOn(reobfJar)
        }
        test {
            useJUnitPlatform()
            testLogging {
                events(*org.gradle.api.tasks.testing.logging.TestLogEvent.values())
                exceptionFormat = org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
                showCauses = true
                showExceptions = true
                showStackTraces = true
            }
        }
        shadowJar {
            mergeServiceFiles()
            archiveClassifier.set("") // Prevent the -all suffix
        }
    }

    dependencies {
        paperweight.paperDevBundle(rootProject.libs.versions.minecraft)

        compileOnly(rootProject.libs.lombok)
        annotationProcessor(rootProject.libs.lombok)
        testCompileOnly(rootProject.libs.lombok)
        testAnnotationProcessor(rootProject.libs.lombok)

        testImplementation(rootProject.libs.junitApi)
        testRuntimeOnly(rootProject.libs.junitEngine)
    }

    repositories {
        mavenCentral()
        maven("https://jitpack.io")
        maven("https://repo.civmc.net/repository/maven-public")

        // For Aikar's ACF-Bukkit and TaskChain-Bukkit
        maven("https://repo.aikar.co/content/groups/aikar/")

        // For ProtocolLib
        maven("https://repo.dmulloy2.net/repository/public/")
    }
}
