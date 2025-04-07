import 'package:flutter/material.dart';
import '../services/person_service.dart';
import '../models/person.dart';
import '../utils/snackbar_service.dart';

class RegisterPersonModal extends StatefulWidget {
  final VoidCallback onRegistered;

  const RegisterPersonModal({super.key, required this.onRegistered});

  @override
  State<RegisterPersonModal> createState() => _RegisterPersonModalState();
}

class _RegisterPersonModalState extends State<RegisterPersonModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pnrController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final person = Person(
        name: _nameController.text.trim(),
        personalNumber: _pnrController.text.trim(),
        vehicleIds: [],
      );

      final success = await PersonService().createPerson(person);

      if (!mounted) return;

      if (success) {
        widget.onRegistered();
      } else {
        SnackBarService.showError(context, 'Något gick fel vid registrering');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Registrera ny användare', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Ange ett namn' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pnrController,
                  decoration: const InputDecoration(
                    labelText: 'Personnummer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Ange personnummer' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Registrera'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
