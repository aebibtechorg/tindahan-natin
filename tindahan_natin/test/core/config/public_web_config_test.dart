import 'package:flutter_test/flutter_test.dart';
import 'package:tindahan_natin/core/config/public_web_config.dart';

void main() {
  group('buildPublicStoreUrl', () {
    test('returns null when base url is empty', () {
      expect(
        buildPublicStoreUrl(slug: 'my-store', baseUrlOverride: ''),
        isNull,
      );
    });

    test('trims trailing slashes before appending hash route', () {
      expect(
        buildPublicStoreUrl(
          slug: 'my-store',
          baseUrlOverride: 'https://public.tindahan.test///',
        ),
        'https://public.tindahan.test/#/store/my-store',
      );
    });

    test('encodes the slug for URL safety', () {
      expect(
        buildPublicStoreUrl(
          slug: 'sari sari/one',
          baseUrlOverride: 'https://public.tindahan.test',
        ),
        'https://public.tindahan.test/#/store/sari%20sari%2Fone',
      );
    });
  });
}