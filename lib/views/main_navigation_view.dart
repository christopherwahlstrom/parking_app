import 'package:flutter/material.dart';
import 'home_view.dart';
import 'parking_view.dart';
import 'history_view.dart';
import '../models/person.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';



class MainNavigationView extends StatefulWidget {
  final Person person;
  final List<String> vehicleIds;

  const MainNavigationView({
    super.key,
    required this.person,
    required this.vehicleIds,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final views = [
      HomeView(person: widget.person),
      ParkingView(personId: widget.person.id , vehicleIds: widget.person.vehicleIds),
      HistoryView(personId: widget.person.id),
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Parking4U',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
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
