import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_vault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secure_vault/features/vault/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Color(0xFF00C853)),
                  const SizedBox(height: 24),
                  Text(
                    'Secure Vault',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Local-first • AES-256 • Biometric'),
                  const SizedBox(height: 48),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<AuthBloc>()
                          .add(AuthenticateWithBiometrics()),
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Desbloquear'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                  if (state is AuthError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.redAccent)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
