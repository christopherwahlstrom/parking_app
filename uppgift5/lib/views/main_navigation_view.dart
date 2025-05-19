import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../models/person.dart';
import '../theme/theme_provider.dart';
import '../services/vehicle_firestore_service.dart';
import '../services/person_firestore_service.dart';
import '../services/parking_space_firestore_service.dart';
import '../services/parking_firestore_service.dart';
import '../blocs/parking_space/parking_space_bloc.dart';
import '../blocs/parking_space/parking_space_event.dart';

import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../blocs/parking/parking_bloc.dart';
import '../blocs/parking/parking_event.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import 'home_view.dart';
import 'parking_view.dart';
import 'history_view.dart';
// import 'login_view.dart';

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

  List<Widget> get _views => [
        HomeView(person: widget.person),
        ParkingView(personId: widget.person.id, vehicleIds: widget.person.vehicleIds),
        HistoryView(personId: widget.person.id),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
  providers: [
    BlocProvider<VehicleBloc>(
      create: (_) => VehicleBloc(
        vehicleService: VehicleFirestoreService(),
        personService: PersonFirestoreService(), 
      )
        ..add(LoadVehicles(widget.person.id)),
    ),
    BlocProvider<ParkingBloc>(
      create: (_) => ParkingBloc(parkingService: ParkingFirestoreService())
        ..add(LoadActiveParkings(widget.person.id)),
    ),
    BlocProvider<ParkingSpaceBloc>(
      create: (_) => ParkingSpaceBloc(parkingSpaceService: ParkingSpaceFirestoreService())
        ..add(LoadParkingSpaces()),
    ),
  ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

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
            body: isMobile
                ? _views[_selectedIndex]
                : Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: _onItemTapped,
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(icon: Icon(Icons.home), label: Text('Hem')),
                          NavigationRailDestination(icon: Icon(Icons.local_parking), label: Text('Parkering')),
                          NavigationRailDestination(icon: Icon(Icons.history), label: Text('Historik')),
                        ],
                      ),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(child: _views[_selectedIndex]),
                    ],
                  ),
            bottomNavigationBar: isMobile
                ? BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hem'),
                      BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'Parkering'),
                      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historik'),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  )
                : null,
          );
        },
      ),
    );
  }
}
