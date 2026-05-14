import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/products/product.dart';
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
      final List data = response.data;
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

  Future<Product> createProduct(Map<String, dynamic> data) async {
    debugPrint('Creating product with data: $data');
    final requestData = Map<String, dynamic>.from(data);
    requestData['id'] ??= _uuid.v4();
    final storeId = requestData['storeId']?.toString();
    final draft = Product.fromJson(requestData);

    try {
      final response = await _dio.post('/products', data: requestData);
      final created = Product.fromJson(Map<String, dynamic>.from(response.data as Map));
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, created.toJson());
        await _local.upsertCachedRecord(_cacheKey(storeId), created.toJson());
      }
      return created;
    } catch (error) {
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, draft.toJson());
        await _local.upsertCachedRecord(_cacheKey(storeId), draft.toJson());
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
    final response = await _dio.get('/products/$id');
    final product = Product.fromJson(response.data);
    await _local.upsertCachedRecord(_cacheKey(product.storeId), product.toJson());
    return product;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    final existing = _local.findCachedRecordByIdWithPrefix('products_', id);
    final storeId = existing?['storeId']?.toString();
    final optimisticMap = {
      ...?existing,
      ...data,
      'id': id,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _dio.put('/products/$id', data: data);
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, optimisticMap);
        await _local.upsertCachedRecord(_cacheKey(storeId), optimisticMap);
      }
    } catch (error) {
      if (storeId != null) {
        await _local.upsertCachedProduct(storeId, optimisticMap);
        await _local.upsertCachedRecord(_cacheKey(storeId), optimisticMap);
      }
      await _local.queueMutation({
        'resource': 'products',
        'method': 'PUT',
        'path': '/products/$id',
        'body': data,
        'storeId': storeId,
        'entityId': id,
      });
    }
  }

  Future<void> deleteProduct(String id) async {
    final existing = _local.findCachedRecordByIdWithPrefix('products_', id);
    final storeId = existing?['storeId']?.toString();
    try {
      await _dio.delete('/products/$id');
      if (storeId != null) {
        await _local.removeCachedProduct(storeId, id);
        await _local.removeCachedRecord(_cacheKey(storeId), id);
      }
    } catch (error) {
      if (storeId != null) {
        await _local.removeCachedProduct(storeId, id);
        await _local.removeCachedRecord(_cacheKey(storeId), id);
      }
      await _local.queueMutation({
        'resource': 'products',
        'method': 'DELETE',
        'path': '/products/$id',
        'storeId': storeId,
        'entityId': id,
      });
    }
  }

  Future<String> uploadImage(XFile file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final response = await _dio.post('/storage/upload', data: formData);
    return response.data['url'];
  }

  Future<List<Product>> searchProducts(String storeId, String query) async {
    final cached = _filterCachedProducts(storeId, query);
    if (cached.isNotEmpty) {
      return _filterCachedProducts(storeId, query);
    }

    try {
      final response = await _dio.get('/products', queryParameters: {'storeId': storeId, 'q': query});
      final List data = response.data as List;
      await _local.cacheProducts(storeId, data.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      return data.map((e) => Product.fromJson(e)).toList();
    } catch (error) {
      return _filterCachedProducts(storeId, query);
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
    final newProduct = await ref.read(productServiceProvider).createProduct(data);
    state = AsyncData([...state.value ?? [], newProduct]);
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
    await ref.read(productServiceProvider).updateProduct(id, data);
    state = AsyncData(updated);
  }

  Future<void> deleteProduct(String id) async {
    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((p) => p.id != id).toList());
    await ref.read(productServiceProvider).deleteProduct(id);
  }
}

final productSearchProvider = FutureProvider.family<List<Product>, String>((ref, key) {
  final parts = key.split('::');
  final storeId = parts[0];
  final query = parts.length > 1 ? parts.sublist(1).join('::') : '';
  return ref.watch(productServiceProvider).searchProducts(storeId, query);
});