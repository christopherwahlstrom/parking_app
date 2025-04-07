# Dokumentation om arbetet: 

# Parking4U 🚘

En enkel parkeringsapp byggd med Flutter som stödjer inloggning, hantering av fordon och parkering i olika zoner.

## 🔧 Genomförda Installationsanvisningar

1. Klona repot: `git clone <repo-url>`
2. Navigera till projektmappen: `cd flutter_parking_app`
3. Installera beroenden: `flutter pub get`
4. Kör appen: `flutter run`
5. Kör server: `dart run server:server`

## ✅ Funktioner

- Inloggning med namn och utloggning
- Skapa ny användare
-  VG , Lägg till/redigera/ta bort fordon
- Lista egna fordon
- Visa lediga parkeringsplatser
- Starta och stoppa parkering
- Visa historik för avslutade parkeringar
-  VG , Mörkt och ljust läge med tema-växling
- Responsivt UI för mobil


## ⚠️ Kända begränsningar

- Ingen faktisk autentisering, bara namnmatchning
- Inga verkliga parkeringsdata eller realtidsuppdateringar
- Alla data sparas endast lokalt



# Flutter Parkeringsapplikation - Uppgift 3

## Introduktion
I denna uppgift ska vi vidareutveckla vår parkeringsapplikation genom att skapa en Flutter-klient som ersätter delar av vårt tidigare CLI. Målet är att bygga en mobilapp för slutanvändare som vill parkera sina fordon.

## Projektstruktur
**Projekt:** `parking_user` (Mobilapplikation)

- **Målplattform:** Mobil (iOS/Android) samt webb/desktop (landskapsläge)
- **Användare:** Personer som behöver parkera sina fordon
- **Navigation:**  
  Använd `NavigationBar` eller `BottomAppBar` för bottennavigering samt `NavigationRail` för sidnavigering.

## Huvudfunktioner
- **Användarregistrering och in-/utloggning**
- **Fordonshantering**
- **Val av parkeringsplats**
- **Hantering av aktiva parkeringar**

## Krav för Godkänt (G)
Notera att kraven beskriver funktionalitet, inte specifika implementationsstrategier. Du bestämmer själv vilka delar du vill ta med från föreläsningarna.

### Generella Krav
- Applikationen ska fungera enligt specifikationen.
- Lämplig felhantering och återkoppling till användaren.
- Datavalidering där det är lämpligt.

### `parking_user` (Mobilapp)
1. **Användarhantering:**  
   - Registrering av nya användare  
   - In-/utloggning

2. **Fordonshantering:**  
   - Lägg till/ta bort fordon  
   - Lista egna fordon

3. **Parkeringsfunktioner:**  
   - Visa lediga parkeringsplatser  
   - Starta parkering  
   - Avsluta parkering  
   - Visa parkeringshistorik

## Inlämningskrav
1. Komplett källkod för applikationen.
2. Kort videodemo som visar:
   - Huvudfunktionerna i appen.
   - Navigation mellan olika vyer.
   - Exempelanvändning.
3. Minimal dokumentation:
   - Installationsanvisningar.
   - Lista över implementerade funktioner.
   - Kända begränsningar.

> **Obs:** Om dokumentationen inkluderas i README.md, ange detta som en kommentar vid inlämningen.

## Extra Utmaningar för VG (minst 2 stycken)
- Lägg till sökfunktioner för listor (t.ex. att söka efter en specifik parkeringsplats).
- Lägg till funktionalitet för att redigera skapat data (t.ex. fordon eller användare).
- Lägg till sorteringsalternativ för listor (t.ex. parkeringsplatser eller pågående/avslutade parkeringar).
- Lägg till stöd för mörkt/ljust tema.
- Eget förslag, med examinator kommunicerat och godkänt.

## Checklista för inlämning

| **Kategori**             | **Krav**                                                        | **Status** | **Kommentar** |
|--------------------------|-----------------------------------------------------------------|------------|---------------|
| **Generella Krav**       | Båda applikationerna ska vara funktionella                      | ⬜         |               |
|                         
