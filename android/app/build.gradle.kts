import java.text.SimpleDateFormat
import java.util.Date
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.github.triplet.play") version "3.9.0"
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.bufferedReader(Charsets.UTF_8).use { reader -> localProperties.load(reader) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val projectName = "GamingEpochs"
val buildTime: String = SimpleDateFormat("yyMMdd.HHmmss").format(Date())

android {
    namespace = "com.liziyi0914.gamingepochs"
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
        applicationId = "com.liziyi0914.gamingepochs"

        minSdk = project.flutter.getProperty("minSdkVersion") as Int?
        targetSdk = project.flutter.getProperty("targetSdkVersion") as Int?
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        buildConfigField("String", "BUILD_TIME", "\"${buildTime}\"")

        setProperty("archivesBaseName", "${projectName}-v${versionName}")
    }

    signingConfigs {
        create("upload") {
            storeFile = rootProject.file("upload.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = "upload"
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }

    productFlavors {
        flavorDimensions += "vendor"
        create("common") {
            dimension = "vendor"
            manifestPlaceholders["CHANNEL"] = "Common"
            manifestPlaceholders["JPUSH_CHANNEL"] = "Common"
        }
        create("google") {
            dimension = "vendor"
            manifestPlaceholders["CHANNEL"] = "Google"
            manifestPlaceholders["JPUSH_CHANNEL"] = "Google"
        }
        create("huawei") {
            dimension = "vendor"
            manifestPlaceholders["CHANNEL"] = "Huawei"
            manifestPlaceholders["JPUSH_CHANNEL"] = "Huawei"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig signingConfigs.debug
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("upload")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    playConfigs {
        register("googleRelease") {
            enabled.set(true)
        }
    }

    applicationVariants.all {
        outputs.all {
            if (this is com.android.build.gradle.internal.api.BaseVariantOutputImpl) {
                val suffix = outputFileName.split(".").last()
                outputFileName = "${projectName}-v${versionName}-${flavorName}-${buildType.name}.${suffix}"
            }
        }
    }
}

play {
    enabled.set(false)
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
    implementation("cn.hutool:hutool-all:5.8.26")
}
