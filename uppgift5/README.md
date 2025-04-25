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

