import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../parse_config.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  void _ensureConfigured() {
    if (!Back4AppKeys.isConfigured) {
      throw AuthException(
        'Back4App keys are not set yet. Add Application ID and Client Key in lib/parse_config.dart.',
      );
    }
  }

  Future<ParseUser?> currentUser() async {
    if (!Back4AppKeys.isConfigured) {
      return null;
    }
    final user = await ParseUser.currentUser();
    if (user is ParseUser && user.sessionToken != null) {
      return user;
    }
    return null;
  }

  Future<ParseUser> register({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();
    final user = ParseUser.createUser(email, password, email);
    final response = await user.signUp();
    if (!response.success || response.results == null) {
      throw AuthException(response.error?.message ?? 'Registration failed.');
    }
    return response.results!.first as ParseUser;
  }

  Future<ParseUser> login({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();
    final user = ParseUser(email, password, null);
    final response = await user.login();
    if (!response.success || response.results == null) {
      throw AuthException(response.error?.message ?? 'Login failed.');
    }
    return response.results!.first as ParseUser;
  }

  Future<void> logout() async {
    _ensureConfigured();
    final user = await currentUser();
    if (user == null) {
      return;
    }
    final response = await user.logout();
    if (!response.success) {
      throw AuthException(response.error?.message ?? 'Logout failed.');
    }
  }
}
