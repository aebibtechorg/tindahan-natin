import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/dashboard/store_stats.dart';

part 'dashboard_service.g.dart';

class DashboardService {
  final Dio _dio;

  DashboardService(this._dio);

  Future<StoreStats> getStoreStats(String storeId) async {
    final response = await _dio.get('/dashboard/stats', queryParameters: {'storeId': storeId});
    return StoreStats.fromJson(response.data);
  }
}

@riverpod
DashboardService dashboardService(Ref ref) {
  return DashboardService(ref.watch(dioClientProvider));
}

@riverpod
Future<StoreStats> storeStats(Ref ref, String storeId) {
  return ref.watch(dashboardServiceProvider).getStoreStats(storeId);
}
