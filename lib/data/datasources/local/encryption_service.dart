import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class EncryptionService {
  Key _getKey([String? targetUid]) {
    final uid = targetUid ?? FirebaseAuth.instance.currentUser?.uid;
    if(uid == null) throw Exception("User not logged in and no target UID provided");
    final bytes = utf8.encode(uid);
    final digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  }

  String encrypt(String plainText, {String? targetUid}) {
    final key = _getKey(targetUid);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decrypt(String encryptedData) {
    final key = _getKey();
    final parts = encryptedData.split(':');
    if(parts.length != 2) throw Exception("Invalid data format");
    final iv = IV.fromBase64(parts[0]);
    final encryptedText = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encryptedText, iv: iv);
  }
}