import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/host_account.dart';

class QrShareHelper {
  // Generates a 32-byte AES key by hashing the 4-digit PIN
  static enc.Key _generateKeyFromPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return enc.Key(Uint8List.fromList(digest.bytes));
  }

  /// Takes a list of accounts and their passwords, encrypts them with a PIN, 
  /// and returns a Base64 string for the QR code.
  static String encodeAndEncrypt(
    List<HostAccount> accounts, 
    List<String> passwords, 
    String pin,
  ) {
    assert(accounts.length == passwords.length);
    
    // Create a JSON list of accounts
    final List<Map<String, dynamic>> payload = [];
    for (int i = 0; i < accounts.length; i++) {
      payload.add({
        'name': accounts[i].accountName,
        'email': accounts[i].email,
        'password': passwords[i],
      });
    }
    final jsonString = jsonEncode(payload);

    // Compress the JSON to save QR code space
    final compressedBytes = zlib.encode(utf8.encode(jsonString));

    // Encrypt using AES and the PIN
    final key = _generateKeyFromPin(pin);
    final iv = enc.IV.fromLength(16); // Initialization Vector
    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encryptBytes(compressedBytes, iv: iv);

    // 4. Combine IV and Encrypted Data, then Base64 encode
    final finalBytes = [...iv.bytes, ...encrypted.bytes];
    return base64Encode(finalBytes);
  }

  /// Reverses the process: Decrypts the QR data using the PIN and returns the accounts.
  static List<Map<String, String>> decryptAndDecode(String qrData, String pin) {
    try {
      final decodedBytes = base64Decode(qrData);
      
      // Extract IV (first 16 bytes) and Encrypted Data (the rest)
      final iv = enc.IV(Uint8List.fromList(decodedBytes.sublist(0, 16)));
      final encryptedBytes = enc.Encrypted(Uint8List.fromList(decodedBytes.sublist(16)));

      // Decrypt
      final key = _generateKeyFromPin(pin);
      final encrypter = enc.Encrypter(enc.AES(key));
      final decryptedCompressedBytes = encrypter.decryptBytes(encryptedBytes, iv: iv);

      // Decompress
      final decompressedBytes = zlib.decode(decryptedCompressedBytes);
      final jsonString = utf8.decode(decompressedBytes);

      // Parse JSON
      final List<dynamic> parsedList = jsonDecode(jsonString);
      return parsedList.map((item) => {
        'name': item['name'].toString(),
        'email': item['email'].toString(),
        'password': item['password'].toString(),
      }).toList();
    } catch (e) {
      throw Exception('Invalid PIN or corrupted QR code.');
    }
  }
}
