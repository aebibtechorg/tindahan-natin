import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';

class SyncCoordinator {
  SyncCoordinator(this._ref, this._dio, this._local);

  final Ref _ref;
  final Dio _dio;
  final LocalStorage _local;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _started = false;
  bool _syncInProgress = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (_hasConnection(results)) {
        unawaited(syncPendingMutations());
      }
    });

    final authState = _ref.read(authStateProvider);
    if (authState.value != null) {
      unawaited(syncPendingMutations());
    }

    _ref.listen(authStateProvider, (previous, next) {
      next.whenData((credentials) {
        if (credentials != null) {
          unawaited(syncPendingMutations());
        }
      });
    });
  }

  Future<void> syncPendingMutations() async {
    if (_syncInProgress) return;
    _syncInProgress = true;

    try {
      final credentials = await _ref.read(authStateProvider.future);
      if (credentials == null) {
        return;
      }

      final pending = _local.getPendingMutations();
      for (final mutation in pending) {
        final applied = await _applyMutation(mutation);
        if (!applied) {
          break;
        }

        final mutationId = mutation['mutationId']?.toString();
        if (mutationId != null && mutationId.isNotEmpty) {
          await _local.removePendingMutation(mutationId);
        }
      }
    } finally {
      _syncInProgress = false;
    }
  }

  Future<bool> _applyMutation(Map<String, dynamic> mutation) async {
    final resource = mutation['resource']?.toString();
    final method = mutation['method']?.toString().toUpperCase();
    final path = mutation['path']?.toString();
    final body = mutation['body'];
    final storeId = mutation['storeId']?.toString();
    final entityId = mutation['entityId']?.toString();

    if (resource == null || method == null || path == null) {
      return false;
    }

    try {
      Response<dynamic>? response;
      switch (method) {
        case 'POST':
          response = await _dio.post<dynamic>(path, data: body);
          break;
        case 'PUT':
          response = await _dio.put<dynamic>(path, data: body);
          break;
        case 'DELETE':
          response = await _dio.delete<dynamic>(path);
          break;
        default:
          return false;
      }

      await _applyLocalResult(resource, method, response.data, storeId, entityId, body);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> _applyLocalResult(
    String resource,
    String method,
    dynamic responseData,
    String? storeId,
    String? entityId,
    dynamic body,
  ) async {
    Map<String, dynamic>? responseMap;
    if (responseData is Map) {
      responseMap = Map<String, dynamic>.from(responseData);
    }

    switch (resource) {
      case 'products':
        if (storeId == null) return;
        final cacheKey = 'products_$storeId';
        if (method == 'DELETE' && entityId != null) {
          await _local.removeCachedProduct(storeId, entityId);
          await _local.removeCachedRecord(cacheKey, entityId);
          return;
        }
        if (responseMap != null) {
          await _local.upsertCachedProduct(storeId, responseMap);
          await _local.upsertCachedRecord(cacheKey, responseMap);
        } else if (body is Map<String, dynamic> && method == 'PUT' && entityId != null) {
          await _local.upsertCachedProduct(storeId, {...body, 'id': entityId});
          await _local.upsertCachedRecord(cacheKey, {...body, 'id': entityId});
        }
        return;
      case 'categories':
        if (storeId == null) return;
        final cacheKey = 'categories_$storeId';
        if (method == 'DELETE' && entityId != null) {
          await _local.removeCachedRecord(cacheKey, entityId);
          return;
        }
        if (responseMap != null) {
          await _local.upsertCachedRecord(cacheKey, responseMap);
        } else if (body is Map<String, dynamic> && method == 'PUT' && entityId != null) {
          await _local.upsertCachedRecord(cacheKey, {...body, 'id': entityId});
        }
        return;
      case 'store':
        if (responseMap != null) {
          await _local.cacheRecords('store_me', [responseMap]);
        } else if (body is Map<String, dynamic>) {
          final cached = _local.getCachedRecords('store_me');
          final existing = cached != null && cached.isNotEmpty ? cached.first : <String, dynamic>{};
          await _local.cacheRecords('store_me', [{...existing, ...body}]);
        }
        return;
      case 'shelves':
        if (storeId == null) return;
        final cacheKey = 'shelves_$storeId';
        if (method == 'DELETE' && entityId != null) {
          await _local.removeCachedRecord(cacheKey, entityId);
          return;
        }
        if (responseMap != null) {
          await _local.upsertCachedRecord(cacheKey, responseMap);
        } else if (body is Map<String, dynamic> && method == 'PUT' && entityId != null) {
          await _local.upsertCachedRecord(cacheKey, {...body, 'id': entityId});
        }
        return;
      case 'productLocations':
        if (storeId == null) return;
        final cacheKey = 'locations_$storeId';
        if (method == 'DELETE' && entityId != null) {
          await _local.removeCachedRecord(cacheKey, entityId);
          return;
        }
        if (responseMap != null) {
          await _local.upsertCachedRecord(cacheKey, responseMap);
        } else if (body is Map<String, dynamic> && method == 'PUT' && entityId != null) {
          await _local.upsertCachedRecord(cacheKey, {...body, 'id': entityId});
        }
        return;
      default:
        return;
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> dispose() async {
    final subscription = _connectivitySubscription;
    if (subscription != null) {
      await subscription.cancel();
    }
  }
}

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final coordinator = SyncCoordinator(
    ref,
    ref.watch(dioClientProvider),
    ref.watch(localStorageProvider),
  );

  unawaited(coordinator.start());
  ref.onDispose(() => unawaited(coordinator.dispose()));
  return coordinator;
});