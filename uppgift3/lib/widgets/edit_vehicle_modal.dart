import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import '../utils/snackbar_service.dart';

class EditVehicleModal extends StatefulWidget {
  final Vehicle vehicle;
  final VoidCallback onSaved;

  const EditVehicleModal({super.key, required this.vehicle, required this.onSaved});

  @override
  State<EditVehicleModal> createState() => _EditVehicleModalState();
}

class _EditVehicleModalState extends State<EditVehicleModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _regController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _regController = TextEditingController(text: widget.vehicle.registrationNumber);
    _typeController = TextEditingController(text: widget.vehicle.type);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      widget.vehicle.registrationNumber = _regController.text.trim();
      widget.vehicle.type = _typeController.text.trim();

      await VehicleService().updateVehicle(widget.vehicle);
      if (!mounted) return;
      SnackBarService.showSuccess(context, 'Fordon uppdaterat');
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
            Text('Redigera fordon', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _regController,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Registreringsnummer', border: OutlineInputBorder()),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Registreringsnummer krävs' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Fordonstyp', border: OutlineInputBorder()),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Fordonstyp krävs' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Spara ändringar')),
          ],
        ),
      ),
    );
  }
}
