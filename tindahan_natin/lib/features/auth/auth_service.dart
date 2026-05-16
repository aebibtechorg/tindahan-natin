import 'package:flutter/foundation.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/config/auth_config.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';

part 'auth_service.g.dart';

class AuthService {
  AuthService() {
    debugPrint('AuthService initialized with Domain: ${AuthConfig.domain}, ClientId: ${AuthConfig.clientId}');
  }
  final Auth0 _auth0 = Auth0(AuthConfig.domain, AuthConfig.clientId);

  Future<Credentials?> getStoredCredentials({int minTtl = 0}) async {
    try {
      final creds = await _auth0.credentialsManager.credentials(minTtl: minTtl);
      return creds;
    } catch (_) {
      return null;
    }
  }

  Future<Credentials?> login() async {
    try {
      final credentials = await _auth0.webAuthentication(scheme: "https").login(
            audience: AuthConfig.audience,
          );
      // Ensure credentials are stored in the native CredentialsManager
      try {
        await _auth0.credentialsManager.storeCredentials(credentials);
      } catch (_) {}
      return credentials;
    } catch (e) {
      // Handle login error
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth0.webAuthentication(scheme: "https").logout();
    } catch (_) {}
    try {
      await _auth0.credentialsManager.clearCredentials();
    } catch (_) {}
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
    // Attempt to restore credentials using Auth0's CredentialsManager
    try {
      final creds = await ref.read(authServiceProvider).getStoredCredentials();
      return creds;
    } catch (_) {
      return null;
    }
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    final credentials = await ref.read(authServiceProvider).login();
    state = AsyncValue.data(credentials);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await ref.read(localStorageProvider).clearCache();
    await ref.read(authServiceProvider).logout();
    state = const AsyncValue.data(null);
  }
}