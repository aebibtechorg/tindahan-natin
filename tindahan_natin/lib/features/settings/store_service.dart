import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';

class StoreService {
  final Dio _dio;
  final LocalStorage _local;

  StoreService(this._dio, this._local);

  Future<Map<String, dynamic>> getMyStore() async {
    final cached = _local.getCachedRecords('store_me');
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    try {
      final response = await _dio.get('/stores/me');
      final data = Map<String, dynamic>.from(response.data as Map);
      await _local.cacheRecords('store_me', [data]);
      return data;
    } catch (error) {
      final cached = _local.getCachedRecords('store_me');
      if (cached != null && cached.isNotEmpty) {
        return cached.first;
      }
      rethrow;
    }
  }

  Future<void> updateStoreName(String name) async {
    final cachedRecords = _local.getCachedRecords('store_me');
    final cached = cachedRecords != null && cachedRecords.isNotEmpty ? cachedRecords.first : null;
    final optimistic = {
      ...?cached,
      'name': name,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _dio.put('/stores/me', data: {'name': name});
    } catch (error) {
      await _local.queueMutation({
        'resource': 'store',
        'method': 'PUT',
        'path': '/stores/me',
        'body': {'name': name},
      });
    }

    await _local.cacheRecords('store_me', [optimistic]);
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService(ref.watch(dioClientProvider), ref.watch(localStorageProvider));
});

final myStoreProvider = FutureProvider<Store?>((ref) async {
  await ref.watch(authStateProvider.future);
  final svc = ref.watch(storeServiceProvider);
  final data = await svc.getMyStore();
  return Store.fromJson(Map<String, dynamic>.from(data));
});
