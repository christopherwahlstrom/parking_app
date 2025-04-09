import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/parking_space/parking_space_bloc.dart';
import '../blocs/parking_space/parking_space_event.dart';
import '../blocs/parking_space/parking_space_state.dart';
import '../services/parking_space_service.dart';
import '../models/parking_space.dart';

class ParkingView extends StatelessWidget {
  final String personId;
  final List<String> vehicleIds;

  const ParkingView({
    super.key,
    required this.personId,
    required this.vehicleIds,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingSpaceBloc(parkingSpaceService: ParkingSpaceService())
        ..add(LoadParkingSpaces()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingSpaceBloc, ParkingSpaceState>(
            builder: (context, state) {
              if (state is ParkingSpaceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ParkingSpaceLoaded) {
                final spaces = state.parkingSpaces;

                if (spaces.isEmpty) {
                  return const Center(child: Text('Inga parkeringszoner tillgängliga.'));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tillgängliga zoner:',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: spaces.length,
                        itemBuilder: (context, index) {
                          final ParkingSpace zone = spaces[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(zone.adress),
                              subtitle: Text('Pris: ${zone.prisPerTimme.toStringAsFixed(0)} kr/timme'),
                              trailing: const Icon(Icons.local_parking),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is ParkingSpaceError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
