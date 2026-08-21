import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_vault/shared/theme/app_theme.dart';
import 'package:secure_vault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secure_vault/features/auth/presentation/pages/login_page.dart';
import 'package:secure_vault/features/vault/presentation/bloc/vault_bloc.dart';
import 'package:secure_vault/features/generator/presentation/bloc/generator_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SecureVaultApp());
}

class SecureVaultApp extends StatelessWidget {
  const SecureVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatus())),
        BlocProvider(create: (_) => VaultBloc()),
        BlocProvider(create: (_) => GeneratorBloc()),
      ],
      child: MaterialApp(
        title: 'Secure Vault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const LoginPage(),
      ),
    );
  }
}
