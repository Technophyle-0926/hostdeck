import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    val localProperties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { localProperties.load(it) }
    }
    val localCompileSdk = localProperties.getProperty("flutter.compileSdkVersion")?.toInt() ?: flutter.compileSdkVersion
    val localMinSdk = localProperties.getProperty("flutter.minSdkVersion")?.toInt() ?: flutter.minSdkVersion
    val localTargetSdk = localProperties.getProperty("flutter.targetSdkVersion")?.toInt() ?: flutter.targetSdkVersion
    val localNdkVersion = localProperties.getProperty("flutter.ndkVersion") ?: flutter.ndkVersion

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(keystorePropertiesFile.inputStream())
    }

    namespace = "dev.meetvishavadia.hostdeck"
    compileSdk = localCompileSdk
    ndkVersion = localNdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "dev.meetvishavadia.hostdeck"
        minSdk = localMinSdk
        targetSdk = localTargetSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storePassword = keystoreProperties.getProperty("storePassword")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            storeFile = keystoreProperties.getProperty("storeFile").let { file(it) }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}

kotlin {
    compilerOptions{
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}
