plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    val localProperties = java.util.Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { localProperties.load(it) }
    }
    val localCompileSdk = localProperties.getProperty("flutter.compileSdkVersion")?.toInt() ?: flutter.compileSdkVersion
    val localMinSdk = localProperties.getProperty("flutter.minSdkVersion")?.toInt() ?: flutter.minSdkVersion
    val localTargetSdk = localProperties.getProperty("flutter.targetSdkVersion")?.toInt() ?: flutter.targetSdkVersion
    val localNdkVersion = localProperties.getProperty("flutter.ndkVersion") ?: flutter.ndkVersion

    namespace = "dev.meetvishavadia.hostdeck"
    compileSdk = localCompileSdk
    ndkVersion = localNdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.meetvishavadia.hostdeck"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = localMinSdk
        targetSdk = localTargetSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}

flutter {
    source = "../.."
}
