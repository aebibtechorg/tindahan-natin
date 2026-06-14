import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/products/product.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:uuid/uuid.dart';

part 'product_service.g.dart';

class ProductService {
  final Dio _dio;
  final LocalStorage _local;
  final _uuid = const Uuid();

  ProductService(this._dio, this._local);

  String _cacheKey(String storeId) => 'products_$storeId';

  List<Product> _filterCachedProducts(String storeId, String query) {
    final cached = _local.getCachedProducts(storeId) ?? const [];
    final lowerQuery = query.toLowerCase();
    return cached
        .map(Product.fromJson)
        .where((product) {
          if (product.id.isEmpty) return false;
          if (query.isEmpty) return true;
          return product.name.toLowerCase().contains(lowerQuery) ||
              (product.description?.toLowerCase().contains(lowerQuery) ?? false) ||
              (product.barcode?.toLowerCase().contains(lowerQuery) ?? false);
        })
        .toList();
  }

  Future<List<Product>> getProducts(String storeId) async {
    final cached = _local.getCachedProducts(storeId);
    if (cached != null && cached.isNotEmpty) {
      return cached.map((e) => Product.fromJson(e)).toList();
    }

    try {
      final response = await _dio.get('/products', queryParameters: {'storeId': storeId});
      final rawData = response.data;
      if (rawData is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Expected List from /products, but got ${rawData?.runtimeType}',
        );
      }
      final List data = rawData;
      await _local.cacheProducts(storeId, data.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      return data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      final cached = _local.getCachedProducts(storeId);
      if (cached != null) {
        return cached.map((e) => Product.fromJson(e)).toList();
      }
      rethrow;
    }
  }

  Future<void> _updateProductLocationCache({
    required String? storeId,
    required String productId,
    required String? shelfId,
  }) async {
    if (storeId == null) return;
    final locationsKey = 'locations_$storeId';
    try {
      final cachedList = _local.getCachedRecords(locationsKey) ?? [];
      final updatedList = cachedList.where((l) => l['productId']?.toString() != productId).toList();
      if (shelfId != null && shelfId.isNotEmpty) {
        updatedList.add({
          'id': 'loc-sync-$productId',
          'productId': productId,
          'shelfId': shelfId,
          'position': 'default',
        });
      }
      await _local.cacheRecords(locationsKey, updatedList);
    } catch (_) {}
  }

  Future<Product> createProduct(Map<String, dynamic> data) async {
    debugPrint('Creating product with data: $data');
    final requestData = Map<String, dynamic>.from(data);
    requestData['id'] ??= _uuid.v4();
    final storeId = requestData['storeId']?.toString();
    final draft = Product.fromJson(requestData);

    try {
      final response = await _dio.post('/products', data: requestData);
      final rawData = response.data;
      if (rawData is! Map) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Expected Map from POST /products, but got ${rawData?.runtimeType}',
        );
      }
      final created = Product.fromJson(Map<String, dynamic>.from(rawData));
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, created.toJson());
        await _local.upsertCachedRecord(_cacheKey(storeId), created.toJson());
        await _updateProductLocationCache(
          storeId: storeId,
          productId: created.id,
          shelfId: created.shelfId,
        );
      }
      return created;
    } catch (error) {
      debugPrint('Create product failed: $error');
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, draft.toJson());
        await _local.upsertCachedRecord(_cacheKey(storeId), draft.toJson());
        await _updateProductLocationCache(
          storeId: storeId,
          productId: draft.id,
          shelfId: draft.shelfId,
        );
      }
      await _local.queueMutation({
        'resource': 'products',
        'method': 'POST',
        'path': '/products',
        'body': requestData,
        'storeId': storeId,
      });
      return draft;
    }
  }

  Future<Product> getProduct(String id) async {
    final cached = _local.findCachedRecordByIdWithPrefix('products_', id);
    
    try {
      final response = await _dio.get('/products/$id');
      final rawData = response.data;
      if (rawData is! Map) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Expected Map from /products/$id, but got ${rawData?.runtimeType}',
        );
      }
      final product = Product.fromJson(rawData as Map<String, dynamic>);
      if (product.id.isNotEmpty) {
        await _local.upsertCachedRecord(_cacheKey(product.storeId), product.toJson());
        await _local.upsertCachedProduct(product.storeId, product.toJson());
      }
      return product;
    } catch (e) {
      if (cached != null) {
        return Product.fromJson(cached);
      }
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data, {String? storeId}) async {
    final sId = storeId ?? _local.findCachedRecordByIdWithPrefix('products_', id)?['storeId']?.toString();
    final existing = sId != null ? _local.getCachedRecordById(_cacheKey(sId), id) : null;
    
    final optimisticMap = {
      ...?existing,
      ...data,
      'id': id,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    if (sId != null) {
      await _local.upsertCachedProduct(sId, optimisticMap);
      await _local.upsertCachedRecord(_cacheKey(sId), optimisticMap);
      await _updateProductLocationCache(
        storeId: sId,
        productId: id,
        shelfId: data['shelfId']?.toString(),
      );
    }

    try {
      await _dio.put('/products/$id', data: data);
    } catch (error) {
      debugPrint('Update product failed: $error');
      await _local.queueMutation({
        'resource': 'products',
        'method': 'PUT',
        'path': '/products/$id',
        'body': data,
        'storeId': sId,
        'entityId': id,
      });
    }
  }

  Future<void> deleteProduct(String id, {String? storeId}) async {
    final sId = storeId ?? _local.findCachedRecordByIdWithPrefix('products_', id)?['storeId']?.toString();

    if (sId != null) {
      await _local.removeCachedProduct(sId, id);
      await _local.removeCachedRecord(_cacheKey(sId), id);
      await _updateProductLocationCache(
        storeId: sId,
        productId: id,
        shelfId: null,
      );
    }

    try {
      await _dio.delete('/products/$id');
    } catch (error) {
      debugPrint('Delete product failed: $error');
      await _local.queueMutation({
        'resource': 'products',
        'method': 'DELETE',
        'path': '/products/$id',
        'storeId': sId,
        'entityId': id,
      });
    }
  }

  Future<String> uploadImage(XFile file) async {
    final formData = FormData.fromMap({
      'file': kIsWeb
          ? MultipartFile.fromBytes(await file.readAsBytes(),
              filename: file.name)
          : await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final response = await _dio.post('/storage/upload', data: formData);
    return response.data['url'];
  }

  Future<Map<String, dynamic>?> lookupProductByBarcode(String barcode, {Dio? dio}) async {
    final lookupDio = dio ?? Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    try {
      // 1. Try Open Food Facts (Food & Drinks)
      var result = await _lookupOFFSchema(lookupDio, barcode, 'world.openfoodfacts.org');
      if (result != null) return result;

      // 2. Try Open Beauty Facts (Cosmetics, Personal Care)
      result = await _lookupOFFSchema(lookupDio, barcode, 'world.openbeautyfacts.org');
      if (result != null) return result;

      // 3. Try Open Products Facts (General products)
      result = await _lookupOFFSchema(lookupDio, barcode, 'world.openproductsfacts.org');
      if (result != null) return result;

      // 4. Try Brocade.io
      result = await _lookupBrocade(lookupDio, barcode);
      if (result != null) return result;

      // 5. Try Google Books (ISBN)
      if (barcode.startsWith('978') || barcode.startsWith('979') || barcode.length == 10) {
        result = await _lookupGoogleBooks(lookupDio, barcode);
        if (result != null) return result;
      }
    } catch (e) {
      debugPrint('Multi-source lookup failed: $e');
    } finally {
      lookupDio.close();
    }
    return null;
  }

  Future<Map<String, dynamic>?> _lookupBrocade(Dio dio, String barcode) async {
    try {
      final response = await dio.get('https://www.brocade.io/api/items/$barcode');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map) {
          final name = data['name']?.toString() ?? data['brand']?.toString();
          if (name != null && name.isNotEmpty) {
            return {
              'name': name,
              'description': data['description']?.toString() ?? '',
              'imageUrl': null,
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Brocade lookup failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _lookupOFFSchema(Dio dio, String barcode, String domain) async {
    try {
      final response = await dio.get('https://$domain/api/v2/product/$barcode.json');
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final product = response.data['product'];
        debugPrint('OFF lookup success from $domain: ${product['product_name']}');
        return {
          'name': product['product_name'] ?? product['generic_name'] ?? product['product_name_en'],
          'description': product['generic_name'] ?? product['product_name'] ?? product['product_name_en'],
          'imageUrl': product['image_url'] ?? product['image_front_url'],
        };
      }
    } catch (e) {
      debugPrint('OFF lookup failed from $domain: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _lookupGoogleBooks(Dio dio, String barcode) async {
    try {
      final response = await dio.get('https://www.googleapis.com/books/v1/volumes?q=isbn:$barcode');
      if (response.statusCode == 200 && response.data['totalItems'] > 0) {
        final book = response.data['items'][0]['volumeInfo'];
        return {
          'name': book['title'],
          'description': book['description'] ?? (book['authors'] as List?)?.join(', '),
          'imageUrl': book['imageLinks']?['thumbnail'],
        };
      }
    } catch (e) {
      debugPrint('Google Books lookup failed: $e');
    }
    return null;
  }

  Future<List<Product>> searchProducts(String storeId, String query) async {
    final cached = _filterCachedProducts(storeId, query);

    try {
      final response = await _dio.get('/products', queryParameters: {'storeId': storeId, 'q': query});
      final rawData = response.data;
      if (rawData is! List) {
        return cached;
      }
      final List data = rawData;
      // Do not cache search results to avoid overwriting the full list
      return data.map((e) => Product.fromJson(e)).toList();
    } catch (error) {
      return cached;
    }
  }
}

@riverpod
ProductService productService(Ref ref) {
  return ProductService(ref.watch(dioClientProvider), ref.watch(localStorageProvider));
}

@riverpod
class Products extends _$Products {
  @override
  Future<List<Product>> build(String storeId) {
    return ref.watch(productServiceProvider).getProducts(storeId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(productServiceProvider).getProducts(storeId));
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    final previousState = state.value ?? [];
    
    // We don't have the ID yet if it's new, so we might need a temporary ID for optimistic UI
    // but the service handles ID generation if not provided.
    // For simplicity, let's let the service create it and then we update state.
    // If we want true optimistic, we should generate ID here.
    final id = data['id'] ?? const Uuid().v4();
    final optimisticData = {...data, 'id': id};
    final newProduct = Product.fromJson(optimisticData);
    
    state = AsyncData([...previousState, newProduct]);
    
    try {
      final created = await ref.read(productServiceProvider).createProduct(optimisticData);
      // Update with the server version (which might have more fields)
      state = AsyncData(
        (state.value ?? []).map((p) => p.id == id ? created : p).toList()
      );
      ref.invalidate(productLocationsProvider(storeId));
    } catch (e) {
      // Keep the optimistic one since it's queued
      ref.invalidate(productLocationsProvider(storeId));
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    final previousState = state.value ?? [];
    final updated = previousState
        .map((product) {
          if (product.id != id) return product;
          return Product.fromJson({
            ...product.toJson(),
            ...data,
            'id': product.id,
          });
        })
        .toList();
    
    state = AsyncData(updated);
    
    try {
      await ref.read(productServiceProvider).updateProduct(id, data, storeId: storeId);
      ref.invalidate(productLocationsProvider(storeId));
    } catch (e) {
      // Keep optimistic since it's queued
      ref.invalidate(productLocationsProvider(storeId));
    }
  }

  Future<void> deleteProduct(String id) async {
    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((p) => p.id != id).toList());
    
    try {
      await ref.read(productServiceProvider).deleteProduct(id, storeId: storeId);
      ref.invalidate(productLocationsProvider(storeId));
    } catch (e) {
      // Keep it deleted since it's queued
      ref.invalidate(productLocationsProvider(storeId));
    }
  }
}

final productSearchProvider = FutureProvider.family<List<Product>, String>((ref, key) {
  final parts = key.split('::');
  final storeId = parts[0];
  final query = parts.length > 1 ? parts.sublist(1).join('::') : '';
  return ref.watch(productServiceProvider).searchProducts(storeId, query);
});