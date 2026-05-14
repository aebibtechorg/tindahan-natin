class PublicWebConfig {
  static const String baseUrl = String.fromEnvironment(
    'PUBLIC_WEB_APP_BASE_URL',
    defaultValue: '',
  );

  static bool get hasBaseUrl =>
      normalizePublicWebAppBaseUrl(baseUrl).isNotEmpty;
}

String normalizePublicWebAppBaseUrl(String baseUrl) {
  final trimmed = baseUrl.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  return trimmed.replaceFirst(RegExp(r'/+$'), '');
}

String? buildPublicStoreUrl({
  required String slug,
  String? baseUrlOverride,
}) {
  final normalizedBaseUrl = normalizePublicWebAppBaseUrl(
    baseUrlOverride ?? PublicWebConfig.baseUrl,
  );
  final trimmedSlug = slug.trim();

  if (normalizedBaseUrl.isEmpty || trimmedSlug.isEmpty) {
    return null;
  }

  return '$normalizedBaseUrl/#/store/${Uri.encodeComponent(trimmedSlug)}';
}