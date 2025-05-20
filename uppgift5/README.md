Sammanfattning – Flutter Parkeringsapp, Uppgift 5: Firebase Integration
1. Firebase Setup
Jag har skapat ett nytt Firebase-projekt och kopplat det till min Flutter-app.
Firestore är aktiverat i region eu3 och används i test mode.
Firebase Authentication är aktiverat med Email/Password som inloggningsmetod.
2. Firestore Repositories
Alla repositories (person, vehicle, parking, parking_space) är migrerade till Firestore.
CRUD-operationer sker nu direkt mot Firestore via dedikerade service-klasser.
3. Authentication
Inloggning och registrering sker via Firebase Authentication med email och lösenord.
AuthBloc hanterar autentiseringsflödet och UI:t uppdateras automatiskt baserat på authStateChanges-streamen.
Felhantering visas tydligt i UI:t vid t.ex. felaktig inloggning.
4. BLoC-integration
Alla BLoCs (auth, vehicle, parking, parking_space) är anpassade för att använda Firestore och Firebase Auth.
Funktionaliteten från tidigare version är bibehållen, men nu med molnbaserad backend.
5. Realtidsuppdatering (VG)
Jag har implementerat realtidsuppdatering (streams) för både fordon och parkeringar.
Detta innebär att UI:t automatiskt uppdateras när data ändras i Firestore, utan att användaren behöver ladda om manuellt.
Jag använder emit.forEach i mina BLoCs för att hantera dessa streams.
6. UI och användarflöde
Appen visar login/register-vy om användaren inte är inloggad, och huvudvyer när användaren är autentiserad.
Användaren kan:
Logga in/registrera sig
Se, lägga till och ta bort fordon
Starta och stoppa parkeringar
Se historik över avslutade parkeringar
All data hämtas och uppdateras i realtid från Firestore.
7. Felhantering och användarvänlighet
Felmeddelanden visas i UI:t vid t.ex. misslyckad inloggning, saknade fordon eller problem med parkering.
Appen är responsiv och fungerar med både ljust och mörkt tema.
8. Sammanfattning
Alla krav för Godkänt och VG är uppfyllda:
Firebase Auth och Firestore används för all data och autentisering.
BLoC-arkitektur är bibehållen och anpassad.
Realtidsuppdatering är implementerad för fordon och parkeringar.
Appen är testad och fungerar enligt kravspecifikationen.


# Parking4U 🚘 - Uppgift 5: Firebase Integration

Denna uppgift innebär en migrering av Flutter-applikationen *Parking4U* från en HTTP-baserad backend till Firebase, med implementering av både Firebase Authentication och Cloud Firestore för användarhantering och datalagring. [cite: 1, 2, 3]

## 🚀 Mål

-   Implementera Firebase Authentication för användarhantering [cite: 4]
-   Migrera befintliga repositories för att använda Cloud Firestore [cite: 4]
-   Integrera Firebase-funktionalitet med existerande BLOC-arkitektur [cite: 4]

## 🔧 Installation och Konfiguration

1.  **Firebase Setup:**

    -   Skapa ett nytt Firebase-projekt i Firebase Console. [cite: 6, 7, 8]
    -   Aktivera Firestore Database och välj en region (eu3) samt starta i test mode. [cite: 6, 7, 8]
    -   Aktivera Email/Password som sign-in metod i Authentication. [cite: 6, 7, 8]
    -   Installera Firebase CLI (följ föreläsning 12 eller officiella dokumentationen). [cite: 9]
2.  **Firestore Repositories:**

    -   Migrera alla befintliga repositories till Firestore (se föreläsning 12 för exempel). [cite: 9, 10]
3.  **Authentication:**

    -   Följ guiderna eller föreläsning 13 för Firebase Authentication implementation. [cite: 10]
        -   Kom igång med Firebase Auth och streama auth state:  
            [https://firebase.google.com/docs/auth/flutter/start](https://firebase.google.com/docs/auth/flutter/start)
        -   Implementera email/password inloggning och registrering:  
            [https://firebase.google.com/docs/auth/flutter/password-auth](https://firebase.google.com/docs/auth/flutter/password-auth)

## ✅ Funktioner

-   Firebase Authentication för användarhantering
    -   Inloggning/registrering med email och lösenord
    -   Korrekt hantering av autentiseringsstate i AuthBloc
    -   Lämplig felhantering för autentiseringsfel
-   Firestore Implementation
    -   Fullständig migrering av alla repositories till Firestore
-   Integration med Existerande BLOCs
    -   Anpassning av BLoCs för att hantera Firebase API
    -   Bibehållen funktionalitet från tidigare implementation

## 🧪 Setup

1.  Lägg till Firebase Auth dependency:

    ```
    flutter pub add firebase_auth
    ```
2.  Implementera AuthRepository (se föreläsning 13 och guiderna för hjälp) [cite: 13, 14, 15, 16]

    ```dart
    class FirebaseAuthRepository {
      final _auth = FirebaseAuth.instance;

      // Stream som uppdateras vid auth state changes
      Stream<User?> get authStateChanges => _auth.authStateChanges();

      Future<UserCredential> signIn(String email, String password);
      Future<UserCredential> register (String email, String password);
      Future<void> signOut();
    }
    ```

## ⚠️ Viktigt att notera om Authentication

-   Använd `authStateChanges()` stream för att lyssna på auth-status. [cite: 16]
-   UI bör uppdateras baserat på denna stream:
    -   Autentiserad: Visa app-vyer
    -   Ej autentiserad: Visa login/register-vyer
-   Alla Firebase Auth API-anrop (login/logout) uppdaterar automatiskt denna stream. [cite: 16]

## ✨ Extra Utmaningar för VG (gör minst 1)

1.  **Realtidsuppdateringar:**

    -   Implementera realtidslyssning på Firestore-ändringar. [cite: 17]
    -   Använd `emit.forEach` i BLOCs för att hantera streams. [cite: 17]
    -   Se exempel: [Firestore realtime changes](https://firebase.google.com/docs/firestore/query-data/listen)
2.  **Utökad Autentisering:**

    -   Lägg till inloggning via valfri tredjepartsleverantör (Google, Facebook, GitHub, etc.). [cite: 17]
3.  **Firebase Functions för Användarhantering:**

    -   Implementera Cloud Function som skapar användarprofil i Firestore vid registrering. [cite: 17, 18]
    -   Observera: Kräver Firebase billing account (men bör hållas inom free tier, testa på egen risk). [cite: 18]

## 📂 Inlämningskrav

1.  Uppdaterad källkod för applikationen med:

    -   Firebase Authentication implementation
    -   Firestore repositories
2.  Kort videodemo som visar:

    -   Autentiseringsflöde
    -   CRUD-operationer mot Firestore
    -   Eventuella VG-funktioner

## 🔗 Resurser

-   [FlutterFire Documentation](https://firebase.google.com/docs/flutter/setup)
-   [Firebase Authentication](https://firebase.google.com/docs/auth)
-   [Cloud Firestore](https://firebase.google.com/docs/firestore)

