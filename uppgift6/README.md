## ✅ Sammanfattning av Uppgift 6

I denna uppgift har jag implementerat **lokala notifikationer** i Parking4U-appen med hjälp av Flutter och paketet `flutter_local_notifications`. Notifikationssystemet påminner användaren om pågående parkeringar genom schemalagda notiser. 

Jag har:
- Installerat och konfigurerat nödvändiga Flutter-paket för notifikationer och tidszonhantering.
- Utfört plattformsspecifik konfiguration för Android (inklusive rättigheter och build-inställningar).
- Skapat ett NotificationRepository som hanterar schemaläggning, avbrytning och behörigheter för notiser.
- Integrerat notifikationshanteringen i appens BLoC-arkitektur, så att notiser automatiskt schemaläggs när en parkering startas och tas bort när parkeringen avslutas.
- Använt **anpassad ikon och text** i notiserna för att uppfylla VG-kravet på utökad funktionalitet.

Resultatet är en app där användaren får tydliga och informativa påminnelser om sina parkeringar, med korrekt timing och plattformsanpassad implementation.


---
# Parking4U 🚘 - Uppgift 6: Lokala Notifikationer

## Introduktion

I den här uppgiften ska du implementera **lokala notifikationer** i din Flutter-applikation *Parking4U*. Syftet är att påminna användare om utgående parkeringstid, vilket ger dig erfarenhet av att arbeta med plattformsspecifika API:er och systemintegrationer i Flutter.

## 🚀 Mål

* Implementera **lokala notifikationer** för påminnelser på valfri plattform (Android eller iOS).
* Konfigurera **plattformsspecifika inställningar**.
* Integrera **notifikationshantering** med existerande BLoC-arkitektur.

---

## 🔧 Installation och Konfiguration

### 1. Flutter Local Notifications Setup

* **Installera nödvändiga paket:**
    ```
    flutter pub add flutter_local_notifications # grundläggande notifikationer
    flutter pub add timezone # för tidszonhantering
    flutter pub add flutter_timezone # för att hämta enhetens tidszon
    flutter pub add intl # för tidsformatering
    flutter pub add uuid # för slumpmässiga ID:n
    ```
* **Uppdatera grundmodeller:**
    Lägg till sluttid i dina modeller, till exempel i din parkeringsmodell:
    ```dart
    final DateTime endTime; // Används för att beräkna när notiser ska visas
    ```

### 2. Plattformskonfiguration

#### Android (om Android valts som plattform)

* **`android/app/main/AndroidManifest.xml`** - Lägg till under `<application>`:
    ```xml
    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED" />
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
            <action android:name="android.intent.action.QUICKBOOT_POWERON" />
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />
        </intent-filter>
    </receiver>
    ```

* **`android/app/build.gradle`** - Uppdatera:
    ```gradle
    android {
        defaultConfig {
            minSdk = 23
            multiDexEnabled true
        }
        compileSdk = 35
        ndkVersion = "27.0.12077973"
        compileOptions {
            isCoreLibraryDesugaringEnabled = true
            sourceCompatibility = JavaVersion.VERSION_11
            targetCompatibility = JavaVersion.VERSION_11
        }
    }

    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    }
    ```

#### iOS (om iOS valts som plattform)

* **`AppDelegate.swift`** - Lägg till i `application`-funktionen:
    ```swift
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    ```

---

## 3. Notifikationsimplementation

#### Tidszonshantering

Denna kodsnutt är nödvändig för att kunna schemalägga notiser vid exakta tidpunkter och bör köras vid applikationsstart eller vid initialisering av `FlutterLocalNotificationsPlugin`. Det måste ske *innan* du schemalägger din första notis.

```dart
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io' show Platform; // Import for Platform check
import 'package:flutter/foundation.dart' show kIsWeb; // Import for kIsWeb

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}