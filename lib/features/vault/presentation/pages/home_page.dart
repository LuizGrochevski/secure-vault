import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_vault/features/vault/presentation/bloc/vault_bloc.dart';
import 'package:secure_vault/features/vault/presentation/pages/add_edit_page.dart';
import 'package:secure_vault/features/generator/presentation/pages/generator_page.dart';
import 'package:secure_vault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secure_vault/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<VaultBloc>().add(LoadEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.password),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GeneratorPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(Logout());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VaultBloc, VaultState>(
        builder: (context, state) {
          if (state is VaultLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VaultError) {
            return Center(child: Text(state.message));
          }
          if (state is VaultLoaded) {
            if (state.entries.isEmpty) {
              return const Center(child: Text('Nenhuma senha salva ainda'));
            }
            return ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                return ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(entry.title),
                  subtitle: Text(entry.username),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context
                        .read<VaultBloc>()
                        .add(DeleteEntry(entry.id)),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditPage(entry: entry),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
