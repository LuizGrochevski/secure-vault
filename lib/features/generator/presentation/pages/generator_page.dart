import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_vault/features/generator/presentation/bloc/generator_bloc.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de Senhas')),
      body: BlocBuilder<GeneratorBloc, GeneratorState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SelectableText(
                      state.password.isEmpty ? '—' : state.password,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Comprimento: ${state.length}'),
                Slider(
                  value: state.length.toDouble(),
                  min: 8,
                  max: 64,
                  divisions: 56,
                  onChanged: (v) => context
                      .read<GeneratorBloc>()
                      .add(UpdateOptions(v.toInt())),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<GeneratorBloc>().add(GeneratePassword()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Gerar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: state.password.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(
                              ClipboardData(text: state.password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copiado!')),
                          );
                        },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
