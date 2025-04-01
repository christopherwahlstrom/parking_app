import 'package:flutter/material.dart';
import '../services/person_service.dart';
import '../utils/snackbar_service.dart';
import '../widgets/register_person_modal.dart';
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
          MaterialPageRoute(builder: (context) => MainNavigationView(person: person)),
        );
      } else {
        SnackBarService.showError(context, 'Personen finns inte registrerad!');
      }
    }
  }

  void _showRegisterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RegisterPersonModal(
        onRegistered: () {
          Navigator.pop(context);
          SnackBarService.showSuccess(context, 'Användare registrerad!');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Parking4U',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/parking_background.jpg'),
            fit: BoxFit.cover,
          ),
          Container(color: Colors.white.withAlpha((0.85 * 255).toInt())),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Logga in',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ditt namn',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Fyll i ditt namn' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Logga in'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _showRegisterModal,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.lightBlue,
                        side: const BorderSide(color: Colors.blue),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Skapa ny användare'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
