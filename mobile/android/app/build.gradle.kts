plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "bf.paglaafi.pag_laafi"
    compileSdk = 36 // Monte à 36 pour satisfaire shared_preferences
    ndkVersion = "28.2.13676358" // Ajoute cette ligne exacte

    defaultConfig {
        applicationId = "bf.paglaafi.pag_laafi"
        minSdk = flutter.minSdkVersion
        targetSdk = 36 // Aligne-le aussi sur 36
        versionCode = 1
        versionName = "1.0"
    }
    

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // Utilisation de la syntaxe sécurisée pour KTS
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Utilisation de parenthèses pour les dépendances en KTS
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
