import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> savePassword(String email, String password) async {
    await _storage.write(key: 'password_$email', value: password);
  }

  Future<String?> getPassword(String email) async {
    return await _storage.read(key: 'password_$email');
  }

  Future<void> deletePassword(String email) async {
    await _storage.delete(key: 'password_$email');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
