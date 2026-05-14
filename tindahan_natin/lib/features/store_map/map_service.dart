import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';
import 'package:uuid/uuid.dart';

part 'map_service.g.dart';

class MapService {
  final Dio _dio;
  final LocalStorage _local;
  final _uuid = const Uuid();

  MapService(this._dio, this._local);

  String _shelvesKey(String storeId) => 'shelves_$storeId';
  String _locationsKey(String storeId) => 'locations_$storeId';

  List<Shelf> _cachedShelves(String storeId) {
    final cached = _local.getCachedRecords(_shelvesKey(storeId)) ?? const [];
    return cached.map(Shelf.fromJson).toList();
  }

  List<ProductLocation> _cachedLocations(String storeId) {
    final cached = _local.getCachedRecords(_locationsKey(storeId)) ?? const [];
    return cached.map(ProductLocation.fromJson).toList();
  }

  Future<List<Shelf>> getShelves(String storeId) async {
    try {
      final response = await _dio.get('/map/shelves', queryParameters: {'storeId': storeId});
      final data = (response.data as List).map((e) => Shelf.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      await _local.cacheRecords(_shelvesKey(storeId), data.map((shelf) => shelf.toJson()).toList());
      return data;
    } catch (error) {
      return _cachedShelves(storeId);
    }
  }

  Future<Shelf> createShelf(Map<String, dynamic> data) async {
    final requestData = Map<String, dynamic>.from(data);
    requestData['id'] ??= _uuid.v4();
    final storeId = requestData['storeId']?.toString();
    final draft = Shelf.fromJson(requestData);

    try {
      final response = await _dio.post('/map/shelves', data: requestData);
      final created = Shelf.fromJson(Map<String, dynamic>.from(response.data as Map));
      if (storeId != null) {
        await _local.upsertCachedRecord(_shelvesKey(storeId), created.toJson());
      }
      return created;
    } catch (error) {
      if (storeId != null) {
        await _local.upsertCachedRecord(_shelvesKey(storeId), draft.toJson());
      }
      await _local.queueMutation({
        'resource': 'shelves',
        'method': 'POST',
        'path': '/map/shelves',
        'body': requestData,
        'storeId': storeId,
      });
      return draft;
    }
  }

  Future<void> updateShelf(String id, Map<String, dynamic> data) async {
    final existing = _local.findCachedRecordByIdWithPrefix('shelves_', id);
    final storeId = existing?['storeId']?.toString();
    final optimistic = {
      ...?existing,
      ...data,
      'id': id,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _dio.put('/map/shelves/$id', data: data);
    } catch (error) {
      await _local.queueMutation({
        'resource': 'shelves',
        'method': 'PUT',
        'path': '/map/shelves/$id',
        'body': data,
        'storeId': storeId,
        'entityId': id,
      });
    }

    if (storeId != null) {
      await _local.upsertCachedRecord(_shelvesKey(storeId), optimistic);
    }
  }

  Future<void> deleteShelf(String id) async {
    final existing = _local.findCachedRecordByIdWithPrefix('shelves_', id);
    final storeId = existing?['storeId']?.toString();

    try {
      await _dio.delete('/map/shelves/$id');
    } catch (error) {
      await _local.queueMutation({
        'resource': 'shelves',
        'method': 'DELETE',
        'path': '/map/shelves/$id',
        'storeId': storeId,
        'entityId': id,
      });
    }

    if (storeId != null) {
      await _local.removeCachedRecord(_shelvesKey(storeId), id);
    }
  }

  Future<List<ProductLocation>> getProductLocations(String storeId) async {
    try {
      final response = await _dio.get('/map/locations', queryParameters: {'storeId': storeId});
      final data = (response.data as List).map((e) => ProductLocation.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      await _local.cacheRecords(_locationsKey(storeId), data.map((location) => location.toJson()).toList());
      return data;
    } catch (error) {
      return _cachedLocations(storeId);
    }
  }

  Future<ProductLocation> createProductLocation(Map<String, dynamic> data) async {
    final requestData = Map<String, dynamic>.from(data);
    requestData['id'] ??= _uuid.v4();
    final shelfId = requestData['shelfId']?.toString();
    final shelfRecord = shelfId == null ? null : _local.findCachedRecordByIdWithPrefix('shelves_', shelfId);
    final storeId = shelfRecord?['storeId']?.toString();
    final draft = ProductLocation.fromJson(requestData);

    try {
      final response = await _dio.post('/map/locations', data: requestData);
      final created = ProductLocation.fromJson(Map<String, dynamic>.from(response.data as Map));
      if (storeId != null) {
        await _local.upsertCachedRecord(_locationsKey(storeId), created.toJson());
      }
      return created;
    } catch (error) {
      if (storeId != null) {
        await _local.upsertCachedRecord(_locationsKey(storeId), draft.toJson());
      }
      await _local.queueMutation({
        'resource': 'productLocations',
        'method': 'POST',
        'path': '/map/locations',
        'body': requestData,
        'storeId': storeId,
      });
      return draft;
    }
  }

  Future<void> deleteProductLocation(String id) async {
    final existing = _local.findCachedRecordByIdWithPrefix('locations_', id);
    final storeId = existing?['storeId']?.toString();

    try {
      await _dio.delete('/map/locations/$id');
    } catch (error) {
      await _local.queueMutation({
        'resource': 'productLocations',
        'method': 'DELETE',
        'path': '/map/locations/$id',
        'storeId': storeId,
        'entityId': id,
      });
    }

    if (storeId != null) {
      await _local.removeCachedRecord(_locationsKey(storeId), id);
    }
  }
}

@riverpod
MapService mapService(Ref ref) {
  return MapService(ref.watch(dioClientProvider), ref.watch(localStorageProvider));
}

@riverpod
Future<List<Shelf>> shelves(Ref ref, String storeId) {
  return ref.watch(mapServiceProvider).getShelves(storeId);
}

@riverpod
Future<List<ProductLocation>> productLocations(Ref ref, String storeId) {
  return ref.watch(mapServiceProvider).getProductLocations(storeId);
}