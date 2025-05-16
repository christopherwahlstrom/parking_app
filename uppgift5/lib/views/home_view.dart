import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import '../widgets/add_vehicle_modal.dart';
import '../widgets/edit_vehicle_modal.dart';
import '../utils/snackbar_service.dart';

class HomeView extends StatelessWidget {
  final Person person;

  const HomeView({super.key, required this.person});

  void _showAddVehicleModal(BuildContext context) async {
    final vehicleBloc = context.read<VehicleBloc>();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: vehicleBloc,
        child: AddVehicleModal(person: person),
      ),
    );

    if (result == true) {
      if (context.mounted) {
        SnackBarService.showSuccess(context, 'Fordon tillagt!');
      }
    }
  }

  void _editVehicle(BuildContext context, Vehicle vehicle) {
    final vehicleBloc = context.read<VehicleBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: vehicleBloc,
        child: EditVehicleModal(
          vehicle: vehicle,
          personId: person.id,
          onSaved: () {
            vehicleBloc.add(LoadVehicles(person.id));
            SnackBarService.showSuccess(context, 'Fordon uppdaterat!');
          },
        ),
      ),
    );
  }

  void _deleteVehicle(BuildContext context, Vehicle vehicle) {
    context.read<VehicleBloc>().add(
      DeleteVehicle(vehicleId: vehicle.id, personId: person.id),
    );
    SnackBarService.showSuccess(context, 'Fordon borttaget');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleModal(context),
        tooltip: 'Lägg till fordon',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VehicleLoaded) {
              final vehicles = state.vehicles;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👤 Namn: ${person.name}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Personnummer: ${person.personalNumber}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Dina fordon:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (vehicles.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Du har inga fordon ännu!",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = vehicles[index];
                          return Card(
                            color: Theme.of(context).cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text('Registreringsnummer: ${vehicle.registrationNumber}'),
                              subtitle: Text('Fordonstyp: ${vehicle.type}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editVehicle(context, vehicle),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteVehicle(context, vehicle),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            } else if (state is VehicleError) {
              return Center(child: Text('Fel: ${state.message}'));
            }
            // Hantera även initial state
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
