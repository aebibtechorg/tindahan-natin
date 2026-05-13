plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.aebibtech.tindahan_natin"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Use a plain string to set the JVM target to avoid Kotlin DSL deprecation warnings.
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.aebibtech.tindahan_natin"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Provide manifest placeholders required by auth0 plugin. Values can be
        // supplied via environment variables (AUTH0_DOMAIN, AUTH0_SCHEME) or
        // fall back to sensible defaults for local development.
        manifestPlaceholders["auth0Domain"] = System.getenv("AUTH0_DOMAIN") ?: "tindahannatin.jp.auth0.com"
        // Scheme should be a short identifier (no dots). Allow override via AUTH0_SCHEME,
        // otherwise use a simple sensible default for local development.
        manifestPlaceholders["auth0Scheme"] = System.getenv("AUTH0_SCHEME") ?: "demo"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
