import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostdeck/data/datasources/local/encryption_service.dart';
import 'package:hostdeck/data/datasources/local/secure_storage_service.dart';
import 'package:hostdeck/domain/entities/host_account.dart';

class FirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EncryptionService _encryptionService = EncryptionService();

  DocumentReference get _userDoc {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not loggedd in');
    return _firestore.collection('users').doc(uid);
  }

  Future<void> syncUp(
    List<HostAccount> accounts,
    SecureStorageService secureStorage,
  ) async {
    final batch = _firestore.batch();
    final accountsCollection = _userDoc.collection('host_accounts');
    final snapshot = await accountsCollection.get();
    final localEmails = accounts.map((account) => account.email).toSet();
    for (var doc in snapshot.docs) {
      if(!localEmails.contains(doc.id)){
        batch.delete(doc.reference);
      }
    }

    for (var account in accounts) {
      final password = await secureStorage.getPassword(account.email);
      if (password == null) continue;
      final encryptedPassword = _encryptionService.encrypt(password);
      final docRef = accountsCollection.doc(account.email);
      batch.set(docRef, {
        'accountName': account.accountName,
        'email': account.email,
        'encryptedPassword': encryptedPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<List<HostAccount>> syncDown(SecureStorageService secureStorage) async {
    final snapshot = await _userDoc.collection('host_accounts').get();
    final List<HostAccount> remoteAccounts = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final encryptedPassword = data['encryptedPassword'] as String?;
      if (encryptedPassword == null) continue;
      try {
        final decryptedPassword = _encryptionService.decrypt(encryptedPassword);
        await secureStorage.savePassword(data['email'], decryptedPassword);
        remoteAccounts.add(
          HostAccount(
            id: 0,
            accountName: data['accountName'],
            email: data['email'] ?? '',
            maxAppsLimit: 5,
            appsCount: 0,
          ),
        );
      } catch (e) {
        debugPrint("Failed to decrypt account ${data['email']}: $e");
      }
    }
    return remoteAccounts;
  }

  Future<void> addOrUpdateAccount(
    HostAccount account,
    SecureStorageService secureStorage,
  ) async {
    final password = await secureStorage.getPassword(account.email);
    if (password == null) return;
    
    final encryptedPassword = _encryptionService.encrypt(password);
    final docRef = _userDoc.collection('host_accounts').doc(account.email);
    
    await docRef.set({
      'accountName': account.accountName,
      'email': account.email,
      'encryptedPassword': encryptedPassword,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteRemoteAccount(HostAccount account) async {
    final docRef = _userDoc.collection('host_accounts').doc(account.email);
    await docRef.delete();
  }
}
