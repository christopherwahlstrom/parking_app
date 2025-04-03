import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
);
