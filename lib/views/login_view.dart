import 'package:flutter/material.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';
import 'main_navigation_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

        Future<void> _submit() async {
      if (_formKey.currentState!.validate()) {
        final personService = PersonService();
        final person = await personService.getPersonByName(_nameController.text);
    
        if (!mounted) return;
        
        if (person != null) {
          SnackBarService.showSuccess(context, 'Välkommen! ${person.name}');
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigationView(
                person: person
              ),
            ),
          );
        } else {
          SnackBarService.showError(context, 'Personen finns inte registrerad!');
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logga in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ditt namn'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Fyll i ditt namn';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('Logga in')),
            ],
          ),
        ),
      ),
    );
  }
}
