import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/core/utils/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    test('sha1Hash returns uppercase hex', () {
      final hash = EncryptionService.sha1Hash('password');
      expect(hash, isA<String>());
      expect(hash.length, 40);
      expect(hash, equals(hash.toUpperCase()));
    });
  });
}
