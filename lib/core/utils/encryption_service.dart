import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  encrypt.Key? _key;
  encrypt.IV? _iv;

  Future<void> init() async {
    String? keyStr = await _storage.read(key: 'aes_key');
    String? ivStr = await _storage.read(key: 'aes_iv');

    if (keyStr == null || ivStr == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);
      await _storage.write(key: 'aes_key', value: base64Encode(key.bytes));
      await _storage.write(key: 'aes_iv', value: base64Encode(iv.bytes));
      _key = key;
      _iv = iv;
    } else {
      _key = encrypt.Key(base64Decode(keyStr));
      _iv = encrypt.IV(base64Decode(ivStr));
    }
  }

  String encryptText(String plain) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    return encrypter.encrypt(plain, iv: _iv!).base64;
  }

  String decryptText(String encrypted) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    return encrypter.decrypt64(encrypted, iv: _iv!);
  }

  static String sha1Hash(String input) {
    return sha1.convert(utf8.encode(input)).toString().toUpperCase();
  }
}
