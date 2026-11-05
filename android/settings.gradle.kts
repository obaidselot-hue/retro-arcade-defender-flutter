pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    val localProperties = java.util.Properties()
    val localPropertiesFile = file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader().use { localProperties.load(it) }
    }
    val flutterSdkPath = localProperties.getProperty("flutter.sdk") ?: throw GradleException("flutter.sdk not set in local.properties")
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}
include(":app")
