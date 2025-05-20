import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/person.dart';
import '../models/vehicle.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../utils/snackbar_service.dart';

class AddVehicleModal extends StatefulWidget {
  final Person person;

  const AddVehicleModal({
    super.key,
    required this.person,
  });

  @override
  State<AddVehicleModal> createState() => _AddVehicleModalState();
}

class _AddVehicleModalState extends State<AddVehicleModal> {
  final _formKey = GlobalKey<FormState>();
  final _regController = TextEditingController();
  final _typeController = TextEditingController();
  bool _submitted = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newVehicle = Vehicle(
        registrationNumber: _regController.text.trim(),
        type: _typeController.text.trim(),
        ownerId: widget.person.id,
      );
      setState(() => _submitted = true);
      context.read<VehicleBloc>().add(AddVehicle(vehicle: newVehicle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (_submitted && state is VehicleLoaded) {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context, true);
          }
          SnackBarService.showSuccess(context, 'Fordon tillagt!');
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
              Text('Lägg till fordon', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regController,
                decoration: const InputDecoration(
                  labelText: 'Registreringsnummer',
                  border: OutlineInputBorder(),
                ),
                maxLength: 6,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ange ett registreringsnummer' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Fordonstyp (t.ex. Bil)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ange en typ av fordon' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Spara'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
