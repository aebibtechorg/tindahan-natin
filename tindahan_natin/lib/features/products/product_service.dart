import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/products/product.dart';

part 'product_service.g.dart';

class ProductService {
  final Dio _dio;
  final LocalStorage _local;

  ProductService(this._dio, this._local);

  Future<List<Product>> getProducts(String storeId) async {
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
    final response = await _dio.post('/products', data: data);
    return Product.fromJson(response.data);
  }

  Future<Product> getProduct(String id) async {
    final response = await _dio.get('/products/$id');
    return Product.fromJson(response.data);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _dio.put('/products/$id', data: data);
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete('/products/$id');
  }

  Future<String> uploadImage(XFile file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final response = await _dio.post('/storage/upload', data: formData);
    return response.data['url'];
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
    final previousState = state.value;
    try {
      await ref.read(productServiceProvider).updateProduct(id, data);
      // reload products for this store
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => ref.read(productServiceProvider).getProducts(storeId));
    } catch (e) {
      state = AsyncData(previousState ?? []);
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final previousState = state.value;
    state = AsyncData((state.value ?? []).where((p) => p.id != id).toList());
    
    try {
      await ref.read(productServiceProvider).deleteProduct(id);
    } catch (e) {
      state = AsyncData(previousState ?? []);
      rethrow;
    }
  }
}