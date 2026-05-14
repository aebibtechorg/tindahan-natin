import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';

part 'public_store_service.g.dart';

class PublicProduct {
  const PublicProduct({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.shelfId,
    this.shelfName,
  });

  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? shelfId;
  final String? shelfName;

  factory PublicProduct.fromJson(Map<String, dynamic> json) {
    return PublicProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      shelfId: json['shelfId'] as String?,
      shelfName: json['shelfName'] as String?,
    );
  }
}

class PublicStoreService {
  final Dio _dio;

  PublicStoreService(this._dio);

  Future<List<PublicProduct>> searchProducts(String slug, String query) async {
    final response = await _dio.get('/public/stores/$slug/products', queryParameters: {'q': query});
    return (response.data as List)
        .map((e) => PublicProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getStoreInfo(String slug) async {
    debugPrint('Fetching public store info for slug: $slug');
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
Future<List<PublicProduct>> publicProductSearch(Ref ref, String slug, String query) {
  return ref.watch(publicStoreServiceProvider).searchProducts(slug, query);
}

@riverpod
Future<Map<String, dynamic>> publicStoreInfo(Ref ref, String slug) {
  return ref.watch(publicStoreServiceProvider).getStoreInfo(slug);
}