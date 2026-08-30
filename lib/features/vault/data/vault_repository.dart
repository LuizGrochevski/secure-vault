import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_vault/core/constants/app_constants.dart';
import 'package:secure_vault/core/utils/encryption_service.dart';
import 'package:secure_vault/features/vault/domain/entities/vault_entry.dart';
import 'package:uuid/uuid.dart';

class VaultRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final EncryptionService _encryption = EncryptionService();
  final _uuid = const Uuid();

  Future<void> init() async {
    await _encryption.init();
  }

  Future<List<VaultEntry>> getEntries() async {
    final encrypted = await _storage.read(key: AppConstants.entriesKey);
    if (encrypted == null || encrypted.isEmpty) return [];

    String decrypted;
    try {
      decrypted = _encryption.decryptText(encrypted);
    } catch (_) {
      // Best-effort migration from pre-v2 (fixed IV + CBC) blobs.
      final legacy = await _encryption.tryDecryptLegacy(encrypted);
      if (legacy == null) rethrow;
      decrypted = legacy;
      // Re-save under v2 (AES-GCM, per-op IV) so next load is native path.
      final list = jsonDecode(decrypted) as List;
      final entries = list.map((e) => VaultEntry.fromJson(e)).toList();
      await saveEntries(entries);
      return entries;
    }

    final list = jsonDecode(decrypted) as List;
    return list.map((e) => VaultEntry.fromJson(e)).toList();
  }

  Future<void> saveEntries(List<VaultEntry> entries) async {
    final json = jsonEncode(entries.map((e) => e.toJson()).toList());
    final encrypted = _encryption.encryptText(json);
    await _storage.write(key: AppConstants.entriesKey, value: encrypted);
  }

  Future<VaultEntry> addEntry({
    required String title,
    required String username,
    required String password,
    String? url,
    String? notes,
  }) async {
    final entries = await getEntries();
    final entry = VaultEntry(
      id: _uuid.v4(),
      title: title,
      username: username,
      password: password,
      url: url,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    entries.add(entry);
    await saveEntries(entries);
    return entry;
  }

  Future<void> updateEntry(VaultEntry entry) async {
    final entries = await getEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      entries[index] = entry.copyWith(updatedAt: DateTime.now());
      await saveEntries(entries);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    entries.removeWhere((e) => e.id == id);
    await saveEntries(entries);
  }
}
