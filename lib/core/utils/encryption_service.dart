import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

/// Encryption service for Secure Vault.
///
/// v2 format (current):
///   `v2:<base64(iv)>:<base64(ciphertext)>`
///   - AES-256-GCM (authenticated encryption)
///   - 12-byte random IV/nonce **per encryption**
///   - Key stored in FlutterSecureStorage (platform keystore/keychain)
///
/// Legacy format (pre-v2):
///   Single base64 ciphertext with a fixed IV stored in secure storage.
///   Decrypt is attempted best-effort for migration; new writes always use v2.
class EncryptionService {
  static const _keyStorageKey = 'aes_key';
  static const _legacyIvStorageKey = 'aes_iv';
  static const _v2Prefix = 'v2:';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  encrypt.Key? _key;

  /// GCM standard nonce size (96 bits).
  static const int _gcmIvLength = 12;

  Future<void> init() async {
    String? keyStr = await _storage.read(key: _keyStorageKey);

    if (keyStr == null) {
      final key = encrypt.Key.fromSecureRandom(32); // AES-256
      await _storage.write(
        key: _keyStorageKey,
        value: base64Encode(key.bytes),
      );
      _key = key;
      // Do not persist a global IV anymore.
    } else {
      _key = encrypt.Key(base64Decode(keyStr));
    }
  }

  encrypt.Encrypter get _gcmEncrypter =>
      encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.gcm));

  /// Encrypts [plain] with a fresh IV. Returns versioned payload.
  String encryptText(String plain) {
    final iv = encrypt.IV.fromSecureRandom(_gcmIvLength);
    final encrypted = _gcmEncrypter.encrypt(plain, iv: iv);
    return '$_v2Prefix${base64Encode(iv.bytes)}:${encrypted.base64}';
  }

  /// Decrypts v2 payload, or attempts legacy fixed-IV format once.
  String decryptText(String encrypted) {
    if (encrypted.startsWith(_v2Prefix)) {
      return _decryptV2(encrypted);
    }
    return _decryptLegacy(encrypted);
  }

  String _decryptV2(String payload) {
    final body = payload.substring(_v2Prefix.length);
    final parts = body.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid v2 ciphertext format');
    }
    final iv = encrypt.IV(base64Decode(parts[0]));
    return _gcmEncrypter.decrypt64(parts[1], iv: iv);
  }

  /// Best-effort decrypt for data written before GCM migration.
  /// Uses CBC (package default) + IV stored under [aes_iv] if present.
  String _decryptLegacy(String encryptedBase64) {
    // Synchronous path cannot await storage; use a cached legacy IV if we
    // loaded it. For true migration, prefer re-saving entries after load.
    throw StateError(
      'Legacy ciphertext detected. Re-open vault after migration helper '
      'or clear local data and re-create entries. '
      'New writes use AES-GCM (v2).',
    );
  }

  /// Async legacy decrypt used by repository during load/migrate.
  Future<String?> tryDecryptLegacy(String encryptedBase64) async {
    final ivStr = await _storage.read(key: _legacyIvStorageKey);
    if (ivStr == null || _key == null) return null;
    try {
      final iv = encrypt.IV(base64Decode(ivStr));
      final encrypter = encrypt.Encrypter(encrypt.AES(_key!)); // default CBC
      return encrypter.decrypt64(encryptedBase64, iv: iv);
    } catch (_) {
      return null;
    }
  }

  /// SHA-1 for HIBP k-anonymity (password is never sent in full).
  static String sha1Hash(String input) {
    return sha1.convert(utf8.encode(input)).toString().toUpperCase();
  }
}
