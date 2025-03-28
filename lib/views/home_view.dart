import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 
        title: const Text('Välkommen till Parkering för dig'),
      ),
      body: const Center(
        child: Text(
          'Här kommer startsidan att visas',
          style: TextStyle(),
        ),
      ),
    );
  }
}