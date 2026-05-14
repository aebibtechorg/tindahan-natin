import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  final Dio _dio;
  final LocalStorage _local;
  final _uuid = const Uuid();

  CategoryService(this._dio, this._local);

  String _cacheKey(String storeId) => 'categories_$storeId';

  List<Category> _filterCachedCategories(String storeId, String query) {
    final cached = _local.getCachedRecords(_cacheKey(storeId)) ?? const [];
    final lowerQuery = query.toLowerCase();
    return cached
        .map(Category.fromJson)
        .where((category) {
          if (query.isEmpty) return true;
          return category.name.toLowerCase().contains(lowerQuery);
        })
        .toList();
  }

  Future<List<Category>> getCategories(String storeId) async {
    final cached = _filterCachedCategories(storeId, '');
    if (cached.isNotEmpty) {
      return _filterCachedCategories(storeId, '');
    }

    try {
      final res = await _dio.get('/categories', queryParameters: {'storeId': storeId});
      final List data = res.data as List;
      await _local.cacheRecords(
        _cacheKey(storeId),
        data.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
      return data.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (error) {
      return _filterCachedCategories(storeId, '');
    }
  }

  Future<List<Category>> searchCategories(String storeId, String query) async {
    final cached = _filterCachedCategories(storeId, query);
    if (cached.isNotEmpty) {
      return _filterCachedCategories(storeId, query);
    }

    try {
      final res = await _dio.get('/categories', queryParameters: {'storeId': storeId, 'q': query});
      final List data = res.data as List;
      await _local.cacheRecords(
        _cacheKey(storeId),
        data.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
      return data.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (error) {
      return _filterCachedCategories(storeId, query);
    }
  }

  Future<Category> createCategory(String name, String storeId) async {
    final requestData = {
      'id': _uuid.v4(),
      'name': name,
      'storeId': storeId,
    };

    try {
      final res = await _dio.post('/categories', data: requestData);
      final created = Category.fromJson(Map<String, dynamic>.from(res.data as Map));
      await _local.upsertCachedRecord(_cacheKey(storeId), {
        ...created.toJson(),
      });
      return created;
    } catch (error) {
      final draft = Category.fromJson(requestData);
      await _local.upsertCachedRecord(_cacheKey(storeId), draft.toJson());
      await _local.queueMutation({
        'resource': 'categories',
        'method': 'POST',
        'path': '/categories',
        'body': requestData,
        'storeId': storeId,
      });
      return draft;
    }
  }

  Future<void> updateCategory(String id, String name) async {
    final existing = _local.findCachedRecordByIdWithPrefix('categories_', id);
    final storeId = existing?['storeId']?.toString();
    final optimistic = {
      ...?existing,
      'id': id,
      'name': name,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _dio.put('/categories/$id', data: {'name': name});
    } catch (error) {
      await _local.queueMutation({
        'resource': 'categories',
        'method': 'PUT',
        'path': '/categories/$id',
        'body': {'name': name},
        'storeId': storeId,
        'entityId': id,
      });
    }

    if (storeId != null) {
      await _local.upsertCachedRecord(_cacheKey(storeId), optimistic);
    }
  }

  Future<void> deleteCategory(String id) async {
    final existing = _local.findCachedRecordByIdWithPrefix('categories_', id);
    final storeId = existing?['storeId']?.toString();

    try {
      await _dio.delete('/categories/$id');
    } catch (error) {
      await _local.queueMutation({
        'resource': 'categories',
        'method': 'DELETE',
        'path': '/categories/$id',
        'storeId': storeId,
        'entityId': id,
      });
    }

    if (storeId != null) {
      await _local.removeCachedRecord(_cacheKey(storeId), id);
    }
  }
}

final categoryServiceProvider = Provider((ref) => CategoryService(ref.watch(dioClientProvider), ref.watch(localStorageProvider)));

final categoriesProvider = FutureProvider.family<List<Category>, String>((ref, storeId) {
  return ref.watch(categoryServiceProvider).getCategories(storeId);
});

final categorySearchProvider = FutureProvider.family<List<Category>, String>((ref, key) {
  final parts = key.split('::');
  final storeId = parts[0];
  final query = parts.length > 1 ? parts.sublist(1).join('::') : '';
  return ref.watch(categoryServiceProvider).searchCategories(storeId, query);
});
