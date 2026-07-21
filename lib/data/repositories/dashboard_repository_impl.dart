import 'package:hostdeck/presentation/controllers/auth_controller.dart';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:hostdeck/data/models/aggregated_build_model.dart';
import 'package:hostdeck/data/models/project_model.dart';
import 'package:hostdeck/domain/entities/aggregated_build.dart';
import 'package:hostdeck/domain/entities/host_account.dart';
import 'package:hostdeck/domain/entities/project.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import '../datasources/local/database_service.dart';
import '../datasources/remote/api_client.dart';
import 'package:flutter/foundation.dart';
import '../datasources/local/secure_storage_service.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DatabaseService _databaseService;
  final ApiClient _apiClient;
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorageService;
  final AuthController _authController;

  DashboardRepositoryImpl(
    this._databaseService,
    this._apiClient,
    this._authRepository,
    this._secureStorageService,
    this._authController,
  );

  @override
  Stream<Map<String, dynamic>> getDashboardData() async* {
    final currentUser = _authController.appUser.value;
    if (currentUser == null) return; // Not logged in

    if (currentUser.role != UserRole.admin) {
      // --- CLIENT / TESTER / MANAGER LOGIC ---
      // Fetch builds from Firestore matching accessibleProjectIds
      final firestore = FirebaseFirestore.instance;
      
      if (currentUser.accessibleProjectIds.isEmpty) {
        yield {
          'accounts': <HostAccount>[],
          'builds': <AggregatedBuild>[],
          'isFromCache': false,
        };
        return;
      }

      try {
        final snapshot = await firestore.collection(FirestoreCollections.builds)
            .where('projectId', whereIn: currentUser.accessibleProjectIds)
            .get();
          
        final List<AggregatedBuild> remoteBuilds = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final buildModel = AggregatedBuildModel.fromJson(data);
          remoteBuilds.add(buildModel.toEntity());
        }
        
        yield {
          'accounts': <HostAccount>[], 
          'builds': remoteBuilds,
          'isFromCache': false,
        };
      } catch (e) {
        debugPrint('Failed to fetch from Firestore: $e');
      }
      return; // Exit stream for non-admins
    }

    // --- ADMIN LOGIC ---
    // 1. Yield local cached data first
    var localAccounts = await _databaseService.getHostAccounts();

    // Deduplicate accounts by email to fix any existing duplicates in Isar
    final seenEmails = <String>{};
    localAccounts = localAccounts
        .where((a) => seenEmails.add(a.email))
        .toList();

    final localBuilds = await _databaseService.getBuilds();

    yield {
      'accounts': localAccounts,
      'builds': localBuilds,
      'isFromCache': true,
    };

    // 2. Fetch fresh network data concurrently
    try {
      final List<HostAccount> remoteAccounts = [];
      final List<AggregatedBuild> remoteBuilds = [];

      // Run auth for all accounts concurrently
      final authResults = await Future.wait(
        localAccounts.map((account) async {
          try {
            final password = await _secureStorageService.getPassword(
              account.email,
            );
            if (password == null) {
              debugPrint('No password found for ${account.email}');
              return null;
            }
            final authData = await _authRepository.authenticateAccount(
              account.email,
              password,
            );
            return {
              'account': account,
              'idToken': authData['idToken'],
              'localId': authData['localId'],
            };
          } catch (e) {
            // If one account fails, we log it but don't crash the whole sync
            debugPrint('Auth failed for ${account.email}: $e');
            return null;
          }
        }),
      );

      // Run Firestore requests concurrently
      final firestoreResults = await Future.wait(
        authResults.where((r) => r != null).map((authResult) async {
          try {
            final localId = authResult!['localId'] as String;
            final idToken = authResult['idToken'] as String;
            final account = authResult['account'] as HostAccount;

            final profileDoc = await _apiClient.fetchAccountProfile(
              localId,
              idToken,
            );
            int maxApps = 5; // Default fallback
            if (profileDoc.containsKey('fields')) {
              final fields = profileDoc['fields'] as Map<String, dynamic>;
              for (var key in [
                'max_apps',
                'max_apps_limit',
                'limit',
                'plan_limit',
                'app_limit',
              ]) {
                if (fields.containsKey(key)) {
                  final field = fields[key];
                  if (field.containsKey('integerValue')) {
                    maxApps =
                        int.tryParse(field['integerValue'].toString()) ??
                        maxApps;
                    break;
                  }
                }
              }
            }

            final appDocs = await _apiClient.fetchAppsForAccount(
              localId,
              idToken,
            );

            final updatedAccount = HostAccount(
              id: account.id,
              accountName: account.accountName,
              email: account.email,
              maxAppsLimit: maxApps,
              appsCount: appDocs.length,
            );

            List<AggregatedBuild> allBuildsForAccount = [];

            for (var appDoc in appDocs) {
              final String docName = appDoc['name']?.toString() ?? '';
              final appId = docName.split('/').last;

              // App name comes from the app document fields
              final fields = appDoc['fields'] as Map<String, dynamic>? ?? {};
              final appName = fields['name']?['stringValue'] ?? 'Unknown App';
              final appShareKey =
                  fields['cached_share_key']?['stringValue'] ?? '';
              final appDownloadUrl = appShareKey.isNotEmpty
                  ? 'https://appho.st/d/$appShareKey'
                  : '';
              final appIconUrl = fields['logo_url']?['stringValue'] ?? '';

              final fileDocs = await _apiClient.fetchFilesForApp(
                localId,
                appId,
                idToken,
              );

              for (var fileDoc in fileDocs) {
                final buildModel = AggregatedBuildModel.fromFirestoreJson(
                  fileDoc,
                  account.id,
                  appName,
                  appDownloadUrl,
                  appIconUrl,
                );
                allBuildsForAccount.add(buildModel.toEntity());
              }
            }

            return {'account': updatedAccount, 'builds': allBuildsForAccount};
          } catch (e) {
            debugPrint('Firestore fetch failed: $e');
            return null;
          }
        }),
      );

      // Fetch fresh local accounts to avoid race conditions with SettingsController
      var currentLocalAccounts = await _databaseService.getHostAccounts();

      for (var result in firestoreResults) {
        if (result != null) {
          final updatedAcc = result['account'] as HostAccount;
          remoteAccounts.add(updatedAcc);
          remoteBuilds.addAll(result['builds'] as List<AggregatedBuild>);

          final idx = currentLocalAccounts.indexWhere(
            (a) => a.id == updatedAcc.id,
          );
          if (idx != -1) {
            currentLocalAccounts[idx] = updatedAcc;
          }
        }
      }

      // 3. Save fresh data to Isar
      await _databaseService.saveHostAccounts(currentLocalAccounts);
      await _databaseService.saveBuilds(remoteBuilds);

      // 4. Admin syncs these builds up to Firestore so non-admins can access them
      final firestore = FirebaseFirestore.instance;
      
      // Fetch all projects to map builds to their respective projects
      final projectsSnapshot = await firestore.collection(FirestoreCollections.projects).get();
      // Sort projects by appName length descending so more specific matches apply first
      // e.g. "Sentry Admin" matches before "Sentry"
      final List<Project> allProjects = projectsSnapshot.docs
          .map((d) => ProjectModel.fromJson(d.data(), d.id).toEntity())
          .toList()
          ..sort((a, b) => b.appName.length.compareTo(a.appName.length));

      final batch = firestore.batch();
      final buildsCollection = firestore.collection(FirestoreCollections.builds);

      for (int i = 0; i < remoteBuilds.length; i++) {
        var build = remoteBuilds[i];
        
        // Smart match: if the build's app name contains the project's target string
        final matchedProject = allProjects.firstWhereOrNull(
          (p) => p.appName.isNotEmpty && build.projectName.toLowerCase().contains(p.appName.toLowerCase())
        );
        if (matchedProject != null) {
          build = build.copyWith(projectId: matchedProject.id);
          remoteBuilds[i] = build; // Update the list so it saves locally correctly
        }

        if (build.projectId.isNotEmpty) {
          final docId = '${build.projectId}_${build.version}_${build.environment}';
          final docRef = buildsCollection.doc(docId);
          final buildModel = AggregatedBuildModel.fromEntity(build);
          batch.set(docRef, buildModel.toJson(), SetOptions(merge: true));
        }
      }
      
      try {
        await batch.commit();
      } catch (e) {
        debugPrint('Failed to upload builds to Firestore: $e');
      }

      yield {
        'accounts': currentLocalAccounts,
        'builds': remoteBuilds,
        'isFromCache': false,
      };
    } catch (e) {
      // If fetching fails, just end stream without throwing so UI doesn't break
      debugPrint('Network sync error: $e');
    }
  }
}
