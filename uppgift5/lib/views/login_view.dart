import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../utils/snackbar_service.dart';
import '../widgets/register_person_modal.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginRequested(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ));
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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                SnackBarService.showError(context, state.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Logga in',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-post',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Fyll i din e-post' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Lösenord',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.length < 6 ? 'Minst 6 tecken' : null,
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
              );
            },
          ),
        ),
      ),
    );
  }
}