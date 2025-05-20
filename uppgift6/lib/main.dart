import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blocs/repositories/firebase_auth_repository.dart';
import 'theme/theme_provider.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import 'views/login_view.dart';
import 'views/main_navigation_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'services/person_firestore_service.dart';
import 'models/person.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Person?> waitForPerson(String uid, {int retries = 5}) async {
  Person? person;
  int attempts = 0;
  while (person == null && attempts < retries) {
    person = await PersonFirestoreService().getPersonById(uid);
    if (person == null) {
      await Future.delayed(const Duration(milliseconds: 400));
      attempts++;
    }
  }
  return person;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: BlocProvider(
        create: (_) => AuthBloc(
          authRepository: FirebaseAuthRepository(),
          personService: PersonFirestoreService(),
        ),
        child: const ParkingApp(),
      ),
    ),
  );
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Parking App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<Person?>(
              future: waitForPerson(snapshot.data!.uid),
              builder: (context, personSnap) {
                if (personSnap.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (personSnap.hasData && personSnap.data != null) {
                  return MainNavigationView(
                    person: personSnap.data!,
                    vehicleIds: personSnap.data!.vehicleIds,
                  );
                }
                return const Scaffold(
                  body: Center(
                    child: Text('Kunde inte hitta användarprofil. Testa att logga ut och registrera igen.'),
                  ),
                );
              },
            );
          }
          return const LoginView();
        },
      ),
    );
  }
}