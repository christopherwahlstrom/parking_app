import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../models/parking.dart';
import '../models/vehicle.dart';
import '../models/parking_space.dart';
import '../blocs/vehicle/vehicle_event.dart';


import '../blocs/parking/parking_bloc.dart';
import '../blocs/parking/parking_event.dart';
import '../blocs/parking/parking_state.dart';
import '../blocs/parking_space/parking_space_bloc.dart';
import '../blocs/parking_space/parking_space_event.dart';
import '../blocs/parking_space/parking_space_state.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_state.dart';

import '../utils/snackbar_service.dart';

class ParkingView extends StatefulWidget {
  final String personId;
  final List<String> vehicleIds;

  const ParkingView({
    super.key,
    required this.personId,
    required this.vehicleIds,
  });

  @override
  State<ParkingView> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingBloc>().add(LoadActiveParkings(widget.personId));
    context.read<ParkingSpaceBloc>().add(LoadParkingSpaces());
    context.read<VehicleBloc>().add(LoadVehicles(widget.personId));
  }

  Future<String?> _selectVehicleDialog(List<Vehicle> vehicles) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Välj fordon att parkera'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: vehicles.map((v) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(v.registrationNumber),
                  subtitle: Text('Typ: ${v.type}'),
                  onTap: () => Navigator.pop(context, v.id),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _startParking(ParkingSpace space, List<Vehicle> vehicles) async {
    if (vehicles.isEmpty) {
      SnackBarService.showError(context, 'Du har inga registrerade fordon');
      return;
    }

    String selectedVehicleId;
    if (vehicles.length == 1) {
      selectedVehicleId = vehicles.first.id;
    } else {
      final result = await _selectVehicleDialog(vehicles);
      if (!mounted || result == null || result.isEmpty) return;
      selectedVehicleId = result;
    }

    final parking = Parking(
      id: const Uuid().v4(),
      personId: widget.personId,
      vehicleId: selectedVehicleId,
      parkingSpaceId: space.id,
      startTime: DateTime.now(),
      endTime: null,
    );

    context.read<ParkingBloc>().add(StartParking(parking));
  }

  void _stopParking(String parkingId) {
    context.read<ParkingBloc>().add(StopParking(parkingId: parkingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ParkingBloc, ParkingState>(
            listener: (context, state) {
              if (state is ParkingStartedSuccess) {
                SnackBarService.showSuccess(context, 'Parkering startad!');
                context.read<ParkingBloc>().add(LoadActiveParkings(widget.personId));
              } else if (state is ParkingStoppedSuccess) {
                SnackBarService.showSuccess(context, 'Parkering avslutad!');
                context.read<ParkingBloc>().add(LoadActiveParkings(widget.personId));
              } else if (state is ParkingError) {
                SnackBarService.showError(context, state.message);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aktiv parkering:',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<ParkingBloc, ParkingState>(
                  builder: (context, state) {
                    if (state is ParkingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ParkingLoaded) {
                      if (state.parkings.isEmpty) {
                        return const Text('Ingen aktiv parkering.');
                      }
                      return ListView.builder(
                        itemCount: state.parkings.length,
                        itemBuilder: (context, index) {
                          final parking = state.parkings[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text('Zon: ${parking.parkingSpaceId}'),
                              subtitle: Text('Start: ${parking.startTime.toString().substring(0, 16)}'),
                              trailing: ElevatedButton(
                                onPressed: () => _stopParking(parking.id),
                                child: const Text('Stoppa'),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ParkingError) {
                      return Text('Fel: ${state.message}');
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tillgängliga zoner:',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<ParkingSpaceBloc, ParkingSpaceState>(
                  builder: (context, zoneState) {
                    if (zoneState is ParkingSpaceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (zoneState is ParkingSpaceLoaded) {
                      return BlocBuilder<VehicleBloc, VehicleState>(
                        builder: (context, vehicleState) {
                          if (vehicleState is! VehicleLoaded) return const SizedBox();
                          final vehicles = vehicleState.vehicles;

                          return ListView.builder(
                            itemCount: zoneState.parkingSpaces.length,
                            itemBuilder: (context, index) {
                              final space = zoneState.parkingSpaces[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(space.adress),
                                  subtitle: Text('Pris: ${space.prisPerTimme} kr/timme'),
                                  trailing: ElevatedButton(
                                    onPressed: () => _startParking(space, vehicles),
                                    child: const Text('Parkera här'),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (zoneState is ParkingSpaceError) {
                      return Text('Fel: ${zoneState.message}');
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
