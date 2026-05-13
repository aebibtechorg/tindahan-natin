import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';

class CategoryService {
  final Dio _dio;

  CategoryService(this._dio);

  Future<List<Category>> getCategories(String storeId) async {
    final res = await _dio.get('/categories', queryParameters: {'storeId': storeId});
    final List data = res.data as List;
    return data.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<Category> createCategory(String name, String storeId) async {
    final res = await _dio.post('/categories', data: {'name': name, 'storeId': storeId});
    return Category.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  Future<void> updateCategory(String id, String name) async {
    await _dio.put('/categories/$id', data: {'name': name});
  }

  Future<void> deleteCategory(String id) async {
    await _dio.delete('/categories/$id');
  }
}

final categoryServiceProvider = Provider((ref) => CategoryService(ref.watch(dioClientProvider)));

final categoriesProvider = FutureProvider.family<List<Category>, String>((ref, storeId) {
  return ref.watch(categoryServiceProvider).getCategories(storeId);
});
