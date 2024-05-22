import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.bufferedReader(Charsets.UTF_8).use { reader -> localProperties.load(reader) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"

val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.liziyi0914.gamingepochs"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
    compileSdk = project.flutter.getProperty("compileSdkVersion") as Int?
    ndkVersion = project.flutter.getProperty("ndkVersion") as String?

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        named("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.liziyi0914.gamingepochs"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
//        minSdkVersion flutter.minSdkVersion
//        targetSdkVersion flutter.targetSdkVersion
//        versionCode flutterVersionCode.toInteger()
//        versionName flutterVersionName

        minSdk = project.flutter.getProperty("minSdkVersion") as Int?
        targetSdk = project.flutter.getProperty("targetSdkVersion") as Int?
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig signingConfigs.debug
        }
    }
}
//
//flutter {
//    source '../..'
//}
//

//tasks.getByName<FlutterExtension>("flutter") {
//    source = "../.."
//}

project.flutter.source = "../.."

dependencies {
    implementation("cn.hutool:hutool-all:5.8.25")
}
