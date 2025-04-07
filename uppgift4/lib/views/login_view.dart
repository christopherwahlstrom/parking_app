import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
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
      final person = await PersonService().getPersonByName(_nameController.text);

      if (!mounted) return; // Kontrollera om widgeten fortfarande är monterad

      if (person != null) {
        SnackBarService.showSuccess(context, 'Välkommen! ${person.name}');
        await Future.delayed(const Duration(milliseconds: 300));

        if (!mounted) return; // Kontrollera igen efter fördröjningen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigationView(person: person, vehicleIds: person.vehicleIds),
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Parking4U',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Logga in',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ditt namn',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Fyll i ditt namn' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Logga in'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _showRegisterModal,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    side: const BorderSide(color: Colors.indigo),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Skapa ny användare'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
