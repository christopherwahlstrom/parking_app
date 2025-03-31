import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';

class HomeView extends StatefulWidget {
  final Person person;

  const HomeView({super.key, required this.person});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;

  final _regController = TextEditingController();
  final _typeController = TextEditingController();

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

  Future<void> _addVehicle() async {
    final registration = _regController.text.trim();
    final type = _typeController.text.trim();

    if (registration.isEmpty || type.isEmpty) {
      if (!mounted) return;
      SnackBarService.showError(context, 'Alla fält måste fyllas i');
      return;
    }

    final newVehicle = Vehicle(
      registrationNumber: registration,
      type: type,
      ownerId: widget.person.id,
    );

    final createdVehicle = await VehicleService().createVehicle(newVehicle);
    widget.person.vehicleIds.add(createdVehicle.id);
    await PersonService().updatePerson(widget.person);

    if (!mounted) return;
    _regController.clear();
    _typeController.clear();
    Navigator.pop(context);

    if (!mounted) return;
    SnackBarService.showSuccess(context, 'Fordon tillagt');
    _loadVehicles();
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    await VehicleService().deleteVehicle(vehicleId);
    widget.person.vehicleIds.remove(vehicleId);
    await PersonService().updatePerson(widget.person);
    if (!mounted) return;
    _loadVehicles();
    SnackBarService.showSuccess(context, 'Fordon borttaget');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lägg till fordon',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _regController,
                          decoration: const InputDecoration(
                            labelText: 'Registreringsnummer',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _typeController,
                          decoration: const InputDecoration(
                            labelText: 'Fordonstyp',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addVehicle,
                          child: const Text('Spara'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'Lägg till fordon',
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Namn: ${widget.person.name}',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Personnummer: ${widget.person.personalNumber}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('Dina fordon:',
                      style: Theme.of(context).textTheme.titleMedium),
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
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteVehicle(vehicle.id),
                              tooltip: 'Ta bort',
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
