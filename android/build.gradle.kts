buildscript {
    val kotlin_version by extra("2.1.10") // Correct way to define Kotlin version
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0") // Correct syntax
        classpath("com.google.gms:google-services:4.3.14") // Correct syntax
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
