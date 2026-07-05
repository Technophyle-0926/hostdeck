import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<Map<String, dynamic>> fetchAccountProfile(String localId, String idToken) async {
    try {
      final url = 'https://firestore.googleapis.com/v1/projects/${AppConstants.firebaseProjectId}/databases/(default)/documents/private_profiles/$localId';
      
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      return response.data;
    } catch (e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchAppsForAccount(String localId, String idToken) async {
    try {
      final url = 'https://firestore.googleapis.com/v1/projects/${AppConstants.firebaseProjectId}/databases/(default)/documents/editable_profiles/$localId/apps';
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      final data = response.data;
      if (data['documents'] != null) {
        return List<Map<String, dynamic>>.from(data['documents']);
      }
      return [];
    } catch (e) {
      // Return empty list if collection doesn't exist or on error, or you can rethrow based on preference
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> fetchFilesForApp(String localId, String appId, String idToken) async {
    try {
      final url = 'https://firestore.googleapis.com/v1/projects/${AppConstants.firebaseProjectId}/databases/(default)/documents/private_profiles/$localId/apps/$appId/files';
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      final data = response.data;
      if (data['documents'] != null) {
        return List<Map<String, dynamic>>.from(data['documents']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
