import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/products/product.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';

part 'public_store_service.g.dart';

class PublicStoreService {
  final Dio _dio;

  PublicStoreService(this._dio);

  Future<List<Product>> searchProducts(String slug, String query) async {
    final response = await _dio.get('/public/stores/$slug/products', queryParameters: {'q': query});
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getStoreInfo(String slug) async {
    final response = await _dio.get('/public/stores/$slug');
    return {
      'store': Store.fromJson(response.data['store']),
      'shelves': (response.data['shelves'] as List).map((e) => Shelf.fromJson(e)).toList(),
    };
  }
}

@riverpod
PublicStoreService publicStoreService(Ref ref) {
  return PublicStoreService(ref.watch(dioClientProvider));
}

@riverpod
Future<List<Product>> publicProductSearch(Ref ref, String slug, String query) {
  return ref.watch(publicStoreServiceProvider).searchProducts(slug, query);
}

@riverpod
Future<Map<String, dynamic>> publicStoreInfo(Ref ref, String slug) {
  return ref.watch(publicStoreServiceProvider).getStoreInfo(slug);
}