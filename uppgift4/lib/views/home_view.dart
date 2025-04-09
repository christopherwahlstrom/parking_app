// home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import '../widgets/add_vehicle_modal.dart';
import '../widgets/edit_vehicle_modal.dart';
import '../utils/snackbar_service.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../blocs/vehicle/vehicle_state.dart';

class HomeView extends StatefulWidget {
  final Person person;

  const HomeView({super.key, required this.person});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(LoadVehicles(widget.person.id));
  }

  void _showAddVehicleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddVehicleModal(
        person: widget.person,
        onSaved: () {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<VehicleBloc>(context).add(LoadVehicles(widget.person.id));
          });
        },
      ),
    );
  }

  void _showEditVehicleModal(BuildContext context, Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditVehicleModal(
        vehicle: vehicle,
        onSaved: () {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<VehicleBloc>(context).add(LoadVehicles(widget.person.id));
            SnackBarService.showSuccess(context, 'Fordon uppdaterat!');
          });
        },
      ),
    );
  }

  Future<void> _deleteVehicle(BuildContext context, String vehicleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bekräfta radering'),
        content: const Text('Är du säker på att du vill ta bort detta fordon?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Avbryt')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ta bort')),
        ],
      ),
    );

    if (confirmed != true) return;

    BlocProvider.of<VehicleBloc>(context).add(DeleteVehicle(vehicleId: vehicleId, personId: widget.person.id));
    SnackBarService.showSuccess(context, 'Fordon borttaget');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (state is VehicleAddedSuccess) {
          SnackBarService.showSuccess(context, 'Fordon tillagt!');
        } else if (state is VehicleError) {
          SnackBarService.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Välkommen, ${widget.person.name}'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddVehicleModal(context),
          child: const Icon(Icons.add),
          tooltip: 'Lägg till fordon',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VehicleLoaded) {
                if (state.vehicles.isEmpty) {
                  return const Center(child: Text('Inga fordon hittades.'));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 Namn: ${widget.person.name}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Personnummer: ${widget.person.personalNumber}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Dina fordon:',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.vehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = state.vehicles[index];
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
                                    onPressed: () => _showEditVehicleModal(context, vehicle),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteVehicle(context, vehicle.id),
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
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
