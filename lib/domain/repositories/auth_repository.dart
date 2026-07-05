abstract class AuthRepository {
  Future<Map<String, String>> authenticateAccount(String email, String password);
}
