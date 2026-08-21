import 'package:http/http.dart' as http;
import 'package:secure_vault/core/constants/app_constants.dart';
import 'package:secure_vault/core/utils/encryption_service.dart';

class HibpService {
  Future<int> checkPwnedCount(String password) async {
    final hash = EncryptionService.sha1Hash(password);
    final prefix = hash.substring(0, 5);
    final suffix = hash.substring(5);

    final response = await http.get(
      Uri.parse('${AppConstants.hibpApi}$prefix'),
      headers: {'User-Agent': 'SecureVault-Flutter'},
    );

    if (response.statusCode != 200) return -1;

    final lines = response.body.split('\n');
    for (final line in lines) {
      final parts = line.split(':');
      if (parts.length == 2 && parts[0].trim() == suffix) {
        return int.tryParse(parts[1].trim()) ?? 0;
      }
    }
    return 0;
  }
}
