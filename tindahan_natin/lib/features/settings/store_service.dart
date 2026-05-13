import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';

class StoreService {
  final Dio _dio;

  StoreService(this._dio);

  Future<Map<String, dynamic>> getMyStore() async {
    final response = await _dio.get('/stores/me');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> updateStoreName(String name) async {
    await _dio.put('/stores/me', data: {'name': name});
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService(ref.watch(dioClientProvider));
});

final myStoreProvider = FutureProvider<Store?>((ref) async {
  final svc = ref.watch(storeServiceProvider);
  final data = await svc.getMyStore();
  if (data.isEmpty) return null;
  return Store.fromJson(Map<String, dynamic>.from(data));
});
