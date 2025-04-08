# Parking4U 🚘 - Uppgift 4

En vidareutveckling av Flutter-applikationen *Parking4U*, där vi infört **BLoC-pattern** för state management samt börjat skriva enhetstester.

## 🔧 Installationsanvisningar

1. Klona repot:  
   `git clone <repo-url>`
2. Gå till mappen för uppgift 4:  
   `cd parking_app/uppgift4`
3. Installera beroenden:  
   `flutter pub get`
4. Starta appen i emulator:  
   `flutter run`
5. Kör backend/server separat:  
   `dart run server:server`

## ✅ Funktioner (inkl. BLoC-införande)

- Inloggning med namn (via **AuthBloc**)
- Skapa ny användare
- Lista egna fordon (**VehicleBloc**)
- Lägg till, redigera och ta bort fordon
- Lista parkeringszoner (**ParkingSpaceBloc**)
- Starta och stoppa parkering (**ParkingBloc**)
- Visa historik över avslutade parkeringar
- Mörkt/ljust läge med knapp för växling
- Responsiv layout (NavigationRail för större skärmar)

## 🧪 Tester

- Varje BLoC-komponent har minst ett testfall (success + error case)
- **Mocktail** används för att mocka repositories
- **bloc_test** används för att verifiera event/state-flöde

## ⚠️ Kända begränsningar

- Ingen riktig autentisering, endast namnmatchning
- Ingen realtidsdata – alla data laddas om manuellt
- Lokalt sparad data (ej kopplat till backend-databas ännu)
- Testerna täcker ännu inte hela UI:t

## 📂 Mappstruktur

```
lib/
├── blocs/
│   ├── auth/
│   ├── vehicle/
│   ├── parking/
│   └── parking_space/
├── repositories/
├── views/
└── main.dart
```

## ✨ Krav från uppgift 4

| **Kategori**          | **Krav**                                                                      | **Uppfyllt** |
|-----------------------|--------------------------------------------------------------------------------|--------------|
| BLoC                  | Minst fyra BLoC: AuthBloc, VehicleBloc, ParkingBloc, ParkingSpaceBloc         | ✅            |
| Events & States       | Samtliga BLoC definierar events/states korrekt                                | ✅            |
| Testing               | Minst ett test för success + fail-case per BLoC                               | ✅            |
| Mocking               | Mocktail används för att testa repository-förfrågningar                       | ✅            |
| UI-integration        | BlocBuilder och BlocProvider används korrekt                                  | ✅            |
| Extra för VG          | Responsiv design, dark/light toggle                                           | ✅            |

## 🎥 Videogenomgång

Se bifogad videodemonstration i inlämningen där vi visar:
- Inloggning och registrering
- Navigering mellan vyer
- Exempel på fordonshantering
- Start/stop av parkering
- Dark/light toggle
- BLoC-tester i terminal

---

> Denna dokumentation finns även i projektets `uppgift4/README.md`.