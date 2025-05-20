import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pnrController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              name: _nameController.text.trim(),
              personalNumber: _pnrController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
  listener: (context, state) async {
    if (state is! AuthLoading) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
    if (state is AuthLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
    else if (state is AuthSuccess) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      widget.onRegistered();
    }
    else if (state is AuthFailure) {
      SnackBarService.showError(context, state.error);
    }
  },
      child: Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registrera ny användare', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-post',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ange e-post' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
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
      ),
    );
  }
}
