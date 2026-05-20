import 'package:flutter_test/flutter_test.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';

@GenerateMocks([Dio, LocalStorage])
import 'product_lookup_test.mocks.dart';

void main() {
  late ProductService productService;
  late MockDio mainDio;
  late MockLocalStorage localStorage;
  late MockDio lookupDio;

  setUp(() {
    mainDio = MockDio();
    localStorage = MockLocalStorage();
    productService = ProductService(mainDio, localStorage);
    lookupDio = MockDio();
    
    // Default fallback for any request
    when(lookupDio.get(any)).thenAnswer((_) async => Response(
      data: {'status': 0},
      statusCode: 404,
      requestOptions: RequestOptions(path: ''),
    ));
  });

  group('Product Lookup', () {
    test('returns food info from Open Food Facts', () async {
      final barcode = '123456';
      when(lookupDio.get('https://world.openfoodfacts.org/api/v2/product/$barcode.json'))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 1,
                  'product': {
                    'product_name': 'Sample Food',
                    'generic_name': 'Food Description',
                    'image_url': 'http://image.com/food.jpg',
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await productService.lookupProductByBarcode(barcode, dio: lookupDio);

      expect(result, isNotNull);
      expect(result!['name'], 'Sample Food');
      expect(result['description'], 'Food Description');
      expect(result['imageUrl'], 'http://image.com/food.jpg');
    });

    test('returns beauty info from Open Beauty Facts if OFF fails', () async {
      final barcode = 'beauty123';
      
      // Mock OBF success
      when(lookupDio.get('https://world.openbeautyfacts.org/api/v2/product/$barcode.json'))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 1,
                  'product': {
                    'product_name': 'Sample Beauty',
                    'generic_name': 'Beauty Description',
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await productService.lookupProductByBarcode(barcode, dio: lookupDio);

      expect(result, isNotNull);
      expect(result!['name'], 'Sample Beauty');
    });

    test('returns general info from Brocade.io', () async {
      final barcode = 'brocade123';
      
      when(lookupDio.get('https://www.brocade.io/api/items/$barcode'))
          .thenAnswer((_) async => Response(
                data: {
                  'name': 'Brocade Product',
                  'brand': 'Brocade Brand',
                  'description': 'Brocade Description',
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await productService.lookupProductByBarcode(barcode, dio: lookupDio);

      expect(result, isNotNull);
      expect(result!['name'], 'Brocade Product');
      expect(result['description'], 'Brocade Description');
    });

    test('returns book info from Google Books if others fail', () async {
      final barcode = '9781234567890';

      // Mock Google Books success
      when(lookupDio.get(argThat(contains('googleapis.com'))))
          .thenAnswer((_) async => Response(
                data: {
                  'totalItems': 1,
                  'items': [
                    {
                      'volumeInfo': {
                        'title': 'Sample Book',
                        'description': 'Book Description',
                      }
                    }
                  ]
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await productService.lookupProductByBarcode(barcode, dio: lookupDio);

      expect(result, isNotNull);
      expect(result!['name'], 'Sample Book');
    });

    test('returns null if no service finds the product', () async {
      final barcode = 'unknown';
      final result = await productService.lookupProductByBarcode(barcode, dio: lookupDio);
      expect(result, isNull);
    });
  });
}
