class AuthConfig {
  static const String domain = String.fromEnvironment('AUTH0_DOMAIN', defaultValue: '');
  static const String clientId = String.fromEnvironment('AUTH0_CLIENT_ID', defaultValue: '');
  static const String audience = String.fromEnvironment('AUTH0_AUDIENCE', defaultValue: '');
}