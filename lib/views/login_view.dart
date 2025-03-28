import 'package:flutter/material.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

  class _LoginViewState extends State<LoginView> {
    final _formKey = GlobalKey<FormState>();
    final _focusName = FocusNode();
    final _nameController = TextEditingController();

    @override
    void dispose() {
      _focusName.dispose();
      _nameController.dispose();
      super.dispose();
    }

    Future<void> _submit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final personService = PersonService();

        final personExists = await personService.login(_nameController.text);
        if (!mounted) return;

        if (personExists) {
          SnackBarService.showSuccess(context, 'Välkommen! ${_nameController.text}');
          Navigator.pushNamed(context, '/home');
        } else {
          SnackBarService.showError(context, 'Användaren hittades inte');
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Logga in'),
        ),
        body: Padding(
          padding: const EdgeInsets.all (16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
              TextFormField(
                autofocus: true,
                focusNode: _focusName,
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ditt namn'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Fyll i ditt namn';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Logga in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
