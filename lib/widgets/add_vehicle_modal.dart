import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';

class AddVehicleModal extends StatefulWidget {
  final Person person;
  final VoidCallback onSaved;

  const AddVehicleModal({super.key, required this.person, required this.onSaved});

  @override
  State<AddVehicleModal> createState() => _AddVehicleModalState();
}

class _AddVehicleModalState extends State<AddVehicleModal> {
  final _formKey = GlobalKey<FormState>();
  final _regController = TextEditingController();
  final _typeController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newVehicle = Vehicle(
        registrationNumber: _regController.text.trim(),
        type: _typeController.text.trim(),
        ownerId: widget.person.id,
      );

      final created = await VehicleService().createVehicle(newVehicle);
      widget.person.vehicleIds.add(created.id);
      await PersonService().updatePerson(widget.person);

      if (!mounted) return;
      SnackBarService.showSuccess(context, 'Fordon tillagt');
      widget.onSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16, left: 16, right: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lägg till fordon', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _regController,
              decoration: const InputDecoration(labelText: 'Registreringsnummer', border: OutlineInputBorder()),
              maxLength: 6,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Ange ett registreringsnummer' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Fordonstyp (t.ex. Bil)', border: OutlineInputBorder()),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Ange en typ av fordon' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Spara')),
          ],
        ),
      ),
    );
  }
}
