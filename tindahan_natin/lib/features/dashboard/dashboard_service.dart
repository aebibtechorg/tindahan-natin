import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/dashboard/store_stats.dart';

part 'dashboard_service.g.dart';

class DashboardService {
  final Dio _dio;
  final LocalStorage _local;

  DashboardService(this._dio, this._local);

  Future<StoreStats> getStoreStats(String storeId) async {
    final cacheKey = 'stats_$storeId';
    
    try {
      final response = await _dio.get('/dashboard/stats', queryParameters: {'storeId': storeId});
      
      final rawData = response.data;
      if (rawData is! Map) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Expected Map from /dashboard/stats, but got ${rawData?.runtimeType}',
        );
      }
      
      final data = Map<String, dynamic>.from(rawData);
      await _local.cacheRecords(cacheKey, [data]);
      return StoreStats.fromJson(data);
    } catch (error) {
      // Fallback to cache if network fails or response is invalid
      final cached = _local.getCachedRecords(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        try {
          return StoreStats.fromJson(cached.first);
        } catch (e) {
          debugPrint('Error parsing cached stats: $e');
        }
      }
      // If no cache is present, return default empty stats so the dashboard still loads
      return const StoreStats(
        totalSales: 0.0,
        totalCredit: 0.0,
        totalTransactions: 0,
        performanceChange: 0.0,
        dailyPerformance: [],
        topProducts: [],
        alerts: [],
      );
    }
  }
}

@riverpod
DashboardService dashboardService(Ref ref) {
  return DashboardService(
    ref.watch(dioClientProvider),
    ref.watch(localStorageProvider),
  );
}

@riverpod
Future<StoreStats> storeStats(Ref ref, String storeId) {
  return ref.watch(dashboardServiceProvider).getStoreStats(storeId);
}
