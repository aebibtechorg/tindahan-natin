import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/settings/store_membership.dart';

part 'store_service.g.dart';

class StoreService {
  final Dio _dio;
  final LocalStorage _local;

  StoreService(this._dio, this._local);

  Future<List<StoreMembership>> getMemberships() async {
    // Cleanup obsolete single-store cache key if it exists
    await _local.deleteCacheEntry('store_me');

    final cached = _local.getCachedRecords('store_memberships_v2');
    if (cached != null && cached.isNotEmpty) {
      return cached.map((e) => StoreMembership.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    try {
      final response = await _dio.get('/stores/memberships');
      final data = (response.data as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      await _local.cacheRecords('store_memberships_v2', data);
      return data.map((e) => StoreMembership.fromJson(e)).toList();
    } catch (error) {
      final cached = _local.getCachedRecords('store_memberships_v2');
      if (cached != null && cached.isNotEmpty) {
        return cached.map((e) => StoreMembership.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      rethrow;
    }
  }

  Future<void> updateStoreName(String storeId, String name) async {
    final cachedRecords = _local.getCachedRecords('store_memberships_v2') ?? [];
    final updatedRecords = cachedRecords.map((e) {
      final record = Map<String, dynamic>.from(e as Map);
      if (record['storeId'] == storeId) {
        return {
          ...record,
          'storeName': name,
        };
      }
      return record;
    }).toList();

    try {
      await _dio.put('/stores/$storeId', data: {'name': name});
    } catch (error) {
      await _local.queueMutation({
        'resource': 'store',
        'method': 'PUT',
        'path': '/stores/$storeId',
        'body': {'name': name},
      });
    }

    await _local.cacheRecords('store_memberships_v2', updatedRecords);
  }

  Future<String> generateInviteCode(String storeId) async {
    final response = await _dio.post('/stores/$storeId/invite-code');
    final newCode = response.data['inviteCode'] as String;

    // Update local cache
    final cachedRecords = _local.getCachedRecords('store_memberships_v2') ?? [];
    final updatedRecords = cachedRecords.map((e) {
      final record = Map<String, dynamic>.from(e as Map);
      if (record['storeId'] == storeId) {
        return {
          ...record,
          'inviteCode': newCode,
        };
      }
      return record;
    }).toList();
    await _local.cacheRecords('store_memberships_v2', updatedRecords);

    return newCode;
  }

  Future<void> joinStore(String inviteCode) async {
    await _dio.post('/stores/join', data: {'inviteCode': inviteCode});
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService(ref.watch(dioClientProvider), ref.watch(localStorageProvider));
});

final membershipsProvider = FutureProvider<List<StoreMembership>>((ref) async {
  await ref.watch(authStateProvider.future);
  return ref.watch(storeServiceProvider).getMemberships();
});

@riverpod
class ActiveStoreId extends _$ActiveStoreId {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}

final selectedStoreMembershipProvider = Provider<StoreMembership?>((ref) {
  final memberships = ref.watch(membershipsProvider).value ?? [];
  final activeId = ref.watch(activeStoreIdProvider);
  if (activeId == null && memberships.isNotEmpty) return memberships.first;
  if (memberships.isEmpty) return null;
  return memberships.firstWhere((m) => m.storeId == activeId, orElse: () => memberships.first);
});

final myStoreProvider = FutureProvider<Store?>((ref) async {
  final membership = ref.watch(selectedStoreMembershipProvider);
  if (membership == null) return null;

  return Store(
    id: membership.storeId,
    name: membership.storeName,
    slug: membership.storeSlug,
    ownerId: '',
    inviteCode: membership.inviteCode,
  );
});
