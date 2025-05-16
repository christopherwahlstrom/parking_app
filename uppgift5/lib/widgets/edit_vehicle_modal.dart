import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/vehicle.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../utils/snackbar_service.dart';

class EditVehicleModal extends StatefulWidget {
  final Vehicle vehicle;
  final String personId;
  final VoidCallback onSaved;

  const EditVehicleModal({
    super.key,
    required this.vehicle,
    required this.personId,
    required this.onSaved,
  });

  @override
  State<EditVehicleModal> createState() => _EditVehicleModalState();
}

class _EditVehicleModalState extends State<EditVehicleModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _regController;
  late TextEditingController _typeController;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _regController = TextEditingController(text: widget.vehicle.registrationNumber);
    _typeController = TextEditingController(text: widget.vehicle.type);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedVehicle = Vehicle(
        id: widget.vehicle.id,
        registrationNumber: _regController.text.trim(),
        type: _typeController.text.trim(),
        ownerId: widget.personId,
      );
      setState(() => _submitted = true);
      context.read<VehicleBloc>().add(UpdateVehicle(vehicle: updatedVehicle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (_submitted && state is VehicleLoaded) {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
          widget.onSaved();
          _submitted = false;
        } else if (state is VehicleError) {
          SnackBarService.showError(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
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
                decoration: const InputDecoration(labelText: 'Registreringsnummer', border: OutlineInputBorder()),
                maxLength: 6,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ange registreringsnummer' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Fordonstyp', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ange fordonstyp' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('Spara ändringar')),
            ],
          ),
        ),
      ),
    );
  }
}
