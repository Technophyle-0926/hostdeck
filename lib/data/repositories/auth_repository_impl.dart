import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Map<String, String>> authenticateAccount(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${AppConstants.firebaseApiKey}',
        data: {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );

      final data = response.data;
      if (data['idToken'] != null && data['localId'] != null) {
        return {
          'idToken': data['idToken'],
          'localId': data['localId'],
        };
      } else {
        throw Exception('Invalid auth response format');
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown authentication error';
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data['error'];
        if (errorData != null && errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to authenticate $email: $e');
    }
  }
}
