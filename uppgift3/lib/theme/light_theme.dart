import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  cardColor: Colors.white, 
  cardTheme: const CardTheme(
    elevation: 2, 
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
);