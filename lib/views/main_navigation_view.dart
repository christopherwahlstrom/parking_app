import 'package:flutter/material.dart';
import 'home_view.dart';
import 'parking_view.dart';
import 'history_view.dart';
import '../models/person.dart';


class MainNavigationView extends StatefulWidget {
  final Person person;

  const MainNavigationView({
    super.key,
    required this.person,
  });

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final views = [
      HomeView(person: widget.person),
      ParkingView(personId: widget.person.id),
      HistoryView(personId: widget.person.id),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking4U'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hem'),
          BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'Parkering'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historik'),
        ],
      ),
    );
  }
}
