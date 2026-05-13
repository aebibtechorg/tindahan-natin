import 'package:flutter/foundation.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/config/auth_config.dart';

part 'auth_service.g.dart';

class AuthService {
  AuthService() {
    debugPrint('AuthService initialized with Domain: ${AuthConfig.domain}, ClientId: ${AuthConfig.clientId}');
  }
  final Auth0 _auth0 = Auth0(AuthConfig.domain, AuthConfig.clientId);

  Future<Credentials?> login() async {
    try {
      final credentials = await _auth0.webAuthentication(scheme: "demo").login(
            audience: AuthConfig.audience,
          );
      return credentials;
    } catch (e) {
      // Handle login error
      return null;
    }
  }

  Future<void> logout() async {
    await _auth0.webAuthentication(scheme: "demo").logout();
  }
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@riverpod
class AuthState extends _$AuthState {
  @override
  FutureOr<Credentials?> build() async {
    // Check for existing session if possible
    return null;
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    final credentials = await ref.read(authServiceProvider).login();
    state = AsyncValue.data(credentials);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await ref.read(authServiceProvider).logout();
    state = const AsyncValue.data(null);
  }
}