import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';

part 'dio_client.g.dart';

@riverpod
String apiBaseUrl(Ref ref) {
  const defaultHost = 'http://localhost:5000';
  final url = const String.fromEnvironment('SERVER_HTTP', defaultValue: defaultHost);
  debugPrint('API Base URL: $url');
  return url;
}

@riverpod
Dio dioClient(Ref ref) {
  final base = ref.read(apiBaseUrlProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: '$base/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  // Attach an auth interceptor that adds the Auth0 access token when available
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final authState = ref.read(authStateProvider);
          final token = authState.value?.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {
          // ignore and continue without auth header
        }
        handler.next(options);
      },
    ),
  );

  return dio;
}