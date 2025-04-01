// home_view.dart
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';
import '../widgets/add_vehicle_modal.dart';
import '../widgets/edit_vehicle_modal.dart';

class HomeView extends StatefulWidget {
  final Person person;

  const HomeView({super.key, required this.person});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final service = VehicleService();
    final loadedVehicles = await Future.wait(
      widget.person.vehicleIds.map((id) => service.getVehicleById(id)),
    );

    if (!mounted) return;
    setState(() {
      vehicles = loadedVehicles.whereType<Vehicle>().toList();
      isLoading = false;
    });
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bekräfta radering'),
        content: const Text('Är du säker på att du vill ta bort detta fordon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ta bort'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await VehicleService().deleteVehicle(vehicleId);
    widget.person.vehicleIds.remove(vehicleId);
    await PersonService().updatePerson(widget.person);
    if (!mounted) return;
    _loadVehicles();
    SnackBarService.showSuccess(context, 'Fordon borttaget');
  }

  void _editVehicle(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditVehicleModal(
        vehicle: vehicle,
        onSaved: () {
          Navigator.pop(context);
          _loadVehicles();
        },
      ),
    );
  }

  void _showAddVehicleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddVehicleModal(
        person: widget.person,
        onSaved: () {
          Navigator.pop(context);
          _loadVehicles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _showAddVehicleModal,
              child: const Icon(Icons.add),
              tooltip: 'Lägg till fordon',
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Namn: ${widget.person.name}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Personnummer: ${widget.person.personalNumber}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('Dina fordon:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return Card(
                          child: ListTile(
                            title: Text('Registreringsnummer: ${vehicle.registrationNumber}'),
                            subtitle: Text('Fordonstyp: ${vehicle.type}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  tooltip: 'Redigera',
                                  onPressed: () => _editVehicle(vehicle),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Ta bort',
                                  onPressed: () => _deleteVehicle(vehicle.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

