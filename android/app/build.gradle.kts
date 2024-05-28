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
    localPropertiesFile.bufferedReader(Charsets.UTF_8)
        .use { reader -> localProperties.load(reader) }
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

//        minSdk = project.flutter.getProperty("minSdkVersion") as Int?
        minSdk = 23
        targetSdk = project.flutter.getProperty("targetSdkVersion") as Int?
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        buildConfigField("String", "BUILD_TIME", "\"${buildTime}\"")

        setProperty("archivesBaseName", "${projectName}-v${versionName}")

        ndk {
            //选择要添加的对应 cpu 类型的 .so 库。
            abiFilters += listOf("armeabi", "armeabi-v7a", "arm64-v8a", "x86", "x86_64")
            // 还可以添加 'x86', 'x86_64', 'mips', 'mips64'

            debugSymbolLevel = "FULL"
        }

        manifestPlaceholders["CHANNEL"] = "Common"

        manifestPlaceholders["JPUSH_PKGNAME"] = applicationId!!
        manifestPlaceholders["JPUSH_APPKEY"] = "7213d236a7c0d1912bd12bda" //JPush 上注册的包名对应的 Appkey.
        manifestPlaceholders["JPUSH_CHANNEL"] = "common" //暂时填写默认值即可.
//        manifestPlaceholders["MEIZU_APPKEY"] = "MZ-魅族的APPKEY"
//        manifestPlaceholders["MEIZU_APPID"] = "MZ-魅族的APPID"
//        manifestPlaceholders["XIAOMI_APPID"] = "MI-小米的APPID"
//        manifestPlaceholders["XIAOMI_APPKEY"] = "MI-小米的APPKEY"
//        manifestPlaceholders["OPPO_APPKEY"] = "OP-oppo的APPKEY"
//        manifestPlaceholders["OPPO_APPID"] = "OP-oppo的APPID"
//        manifestPlaceholders["OPPO_APPSECRET"] = "OP-oppo的APPSECRET"
//        manifestPlaceholders["VIVO_APPKEY"] = "vivo的APPKEY"
//        manifestPlaceholders["VIVO_APPID"] = "vivo的APPID"
        manifestPlaceholders["HONOR_APPID"] = "104446275"
    }

    signingConfigs {
        create("upload") {
            storeFile = rootProject.file("upload.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = "upload"
            keyPassword = System.getenv("KEY_PASSWORD")
        }
        getByName("debug") {
            storeFile = rootProject.file("upload.jks")
            storePassword = localProperties.getProperty("storePassword") ?: ""
            keyAlias = "upload"
            keyPassword = localProperties.getProperty("keyPassword") ?: ""
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
        create("honor") {
            dimension = "vendor"
            manifestPlaceholders["CHANNEL"] = "Honor"
            manifestPlaceholders["JPUSH_CHANNEL"] = "Honor"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig signingConfigs.debug
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("upload")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
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
                outputFileName =
                    "${projectName}-v${versionName}-${flavorName}-${buildType.name}.${suffix}"
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
    val jgVersion = "5.3.1"

    // region 极光推送
//    implementation("cn.jiguang.sdk:jcore:2.7.2")
//    implementation("cn.jiguang.sdk:jpush:5.2.2")
    implementation("cn.jiguang.sdk:jpush-google:${jgVersion}")
    // 接入华为厂商
//    implementation("com.huawei.agconnect:agconnect-core:1.9.1.301")
//    implementation("com.huawei.hms:push:6.12.0.300")
//    implementation("cn.jiguang.sdk.plugin:huawei:${jgVersion}")
//    implementation("com.huawei.hms:push:6.12.0.300")
//    implementation("cn.jiguang.sdk.plugin:huawei:5.2.2")
    // 接入 FCM 厂商
//    implementation("cn.jiguang.sdk.plugin:fcm:5.2.2")
    // 接入魅族厂商
//    implementation("cn.jiguang.sdk.plugin:meizu:5.2.2")
    // 接入 VIVO 厂商
//    implementation("cn.jiguang.sdk.plugin:vivo:5.2.2")
    // 接入 OPPO 厂商
//    implementation("cn.jiguang.sdk.plugin:oppo:5.2.2")
    // 接入小米厂商
//    implementation("cn.jiguang.sdk.plugin:xiaomi:5.2.2")
    // 接入荣耀厂商
    implementation("cn.jiguang.sdk.plugin:honor:${jgVersion}")
    //引入 libs 中的 aar，如果项目中有此依赖不需要重复引用
    implementation(
        fileTree().apply {
            include("*.jar", "*.aar")
            setDir("libs")
        }
    )
    // endregion

    implementation("cn.hutool:hutool-all:5.8.26")
}
