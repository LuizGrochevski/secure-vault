import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_vault/features/vault/domain/entities/vault_entry.dart';
import 'package:secure_vault/features/vault/presentation/bloc/vault_bloc.dart';
import 'package:secure_vault/core/utils/hibp_service.dart';

class AddEditPage extends StatefulWidget {
  final VaultEntry? entry;
  const AddEditPage({super.key, this.entry});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _userCtrl;
  late final TextEditingController _passCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _notesCtrl;
  int? _pwnedCount;
  bool _checking = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.entry?.title);
    _userCtrl = TextEditingController(text: widget.entry?.username);
    _passCtrl = TextEditingController(text: widget.entry?.password);
    _urlCtrl = TextEditingController(text: widget.entry?.url);
    _notesCtrl = TextEditingController(text: widget.entry?.notes);
  }

  Future<void> _checkLeak() async {
    if (_passCtrl.text.isEmpty) return;
    setState(() => _checking = true);
    final count = await HibpService().checkPwnedCount(_passCtrl.text);
    setState(() {
      _pwnedCount = count;
      _checking = false;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.entry == null) {
      context.read<VaultBloc>().add(AddEntry(
            title: _titleCtrl.text,
            username: _userCtrl.text,
            password: _passCtrl.text,
            url: _urlCtrl.text.isEmpty ? null : _urlCtrl.text,
            notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
          ));
    } else {
      context.read<VaultBloc>().add(UpdateEntry(
            widget.entry!.copyWith(
              title: _titleCtrl.text,
              username: _userCtrl.text,
              password: _passCtrl.text,
              url: _urlCtrl.text.isEmpty ? null : _urlCtrl.text,
              notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
            ),
          ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Nova senha' : 'Editar'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Usuário / Email'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    IconButton(
                      icon: _checking
                          ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.security),
                      onPressed: _checkLeak,
                    ),
                  ],
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            if (_pwnedCount != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _pwnedCount == 0
                      ? '✅ Não encontrada em vazamentos'
                      : '⚠️ Encontrada $_pwnedCount vezes em vazamentos',
                  style: TextStyle(
                    color: _pwnedCount == 0 ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _urlCtrl,
              decoration: const InputDecoration(labelText: 'URL (opcional)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notas'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _urlCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
}
