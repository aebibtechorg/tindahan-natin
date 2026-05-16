import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:uuid/uuid.dart';

part 'category_service.g.dart';

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
    
    try {
      final res = await _dio.get('/categories', queryParameters: {'storeId': storeId});
      final List data = res.data as List;
      await _local.cacheRecords(
        _cacheKey(storeId),
        data.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
      return data.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (error) {
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<Category>> searchCategories(String storeId, String query) async {
    final cached = _filterCachedCategories(storeId, query);

    try {
      final res = await _dio.get('/categories', queryParameters: {'storeId': storeId, 'q': query});
      final List data = res.data as List;
      await _local.cacheRecords(
        _cacheKey(storeId),
        data.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
      return data.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (error) {
      return cached;
    }
  }

  Future<Category> createCategory(String name, String storeId) async {
    final id = _uuid.v4();
    final requestData = {
      'id': id,
      'name': name,
      'storeId': storeId,
    };

    try {
      final res = await _dio.post('/categories', data: requestData);
      final created = Category.fromJson(Map<String, dynamic>.from(res.data as Map));
      await _local.upsertCachedRecord(_cacheKey(storeId), created.toJson());
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

    if (storeId != null) {
      await _local.upsertCachedRecord(_cacheKey(storeId), optimistic);
    }

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
  }

  Future<void> deleteCategory(String id) async {
    final existing = _local.findCachedRecordByIdWithPrefix('categories_', id);
    final storeId = existing?['storeId']?.toString();

    if (storeId != null) {
      await _local.removeCachedRecord(_cacheKey(storeId), id);
    }

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
  }
}

@riverpod
CategoryService categoryService(Ref ref) {
  return CategoryService(ref.watch(dioClientProvider), ref.watch(localStorageProvider));
}

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build(String storeId) {
    return ref.watch(categoryServiceProvider).getCategories(storeId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(categoryServiceProvider).getCategories(storeId));
  }

  Future<Category> addCategory(String name) async {
    final previousState = state.value ?? [];
    final id = const Uuid().v4();
    final newCategory = Category(id: id, name: name, storeId: storeId);
    
    state = AsyncData([...previousState, newCategory]);
    
    try {
      final created = await ref.read(categoryServiceProvider).createCategory(name, storeId);
      state = AsyncData(
        (state.value ?? []).map((c) => c.id == id ? created : c).toList()
      );
      return created;
    } catch (e) {
      // Keep optimistic
      return newCategory;
    }
  }

  Future<void> updateCategory(String id, String name) async {
    final previousState = state.value ?? [];
    final updated = previousState.map((c) => c.id == id ? Category(id: id, name: name, storeId: storeId) : c).toList();
    
    state = AsyncData(updated);
    
    try {
      await ref.read(categoryServiceProvider).updateCategory(id, name);
    } catch (e) {
      // Keep optimistic
    }
  }

  Future<void> deleteCategory(String id) async {
    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((c) => c.id != id).toList());
    
    try {
      await ref.read(categoryServiceProvider).deleteCategory(id);
    } catch (e) {
      // Keep deleted
    }
  }
}

final categorySearchProvider = FutureProvider.family<List<Category>, String>((ref, key) {
  final parts = key.split('::');
  final storeId = parts[0];
  final query = parts.length > 1 ? parts.sublist(1).join('::') : '';
  return ref.watch(categoryServiceProvider).searchCategories(storeId, query);
});
