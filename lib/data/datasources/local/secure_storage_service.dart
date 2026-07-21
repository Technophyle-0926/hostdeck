import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> savePassword(String email, String password) async {
    await _storage.write(key: '${StorageKeys.passwordPrefix}$email', value: password);
  }

  Future<String?> getPassword(String email) async {
    return await _storage.read(key: '${StorageKeys.passwordPrefix}$email');
  }

  Future<void> deletePassword(String email) async {
    await _storage.delete(key: '${StorageKeys.passwordPrefix}$email');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
