import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage.g.dart';

class LocalStorage {
  final Box _productsBox = Hive.box('products_cache');
  final Box _entityBox = Hive.box('entity_cache');
  final Box _pendingMutationsBox = Hive.box('pending_mutations');

  Future<void> cacheProducts(String storeId, List<Map<String, dynamic>> products) async {
    await _productsBox.put('products_$storeId', products);
  }

  List<Map<String, dynamic>>? getCachedProducts(String storeId) {
    final data = _productsBox.get('products_$storeId');
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(
      (data as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  Future<void> cacheRecords(String cacheKey, List<Map<String, dynamic>> records) async {
    await _entityBox.put(cacheKey, records);
  }

  List<Map<String, dynamic>>? getCachedRecords(String cacheKey) {
    final data = _entityBox.get(cacheKey);
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(
      (data as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  Map<String, dynamic>? getCachedRecordById(String cacheKey, String id) {
    final records = getCachedRecords(cacheKey);
    if (records == null) return null;
    for (final record in records) {
      if (record['id']?.toString() == id) {
        return record;
      }
    }
    return null;
  }

  Map<String, dynamic>? findCachedRecordByIdWithPrefix(String keyPrefix, String id) {
    for (final key in _entityBox.keys) {
      final cacheKey = key.toString();
      if (!cacheKey.startsWith(keyPrefix)) continue;

      final records = getCachedRecords(cacheKey);
      if (records == null) continue;

      for (final record in records) {
        if (record['id']?.toString() == id) {
          return record;
        }
      }
    }

    for (final key in _productsBox.keys) {
      final cacheKey = key.toString();
      if (!cacheKey.startsWith(keyPrefix)) continue;

      final records = getCachedProducts(cacheKey.replaceFirst('products_', ''));
      if (records == null) continue;

      for (final record in records) {
        if (record['id']?.toString() == id) {
          return record;
        }
      }
    }

    return null;
  }

  Future<void> upsertCachedRecord(String cacheKey, Map<String, dynamic> record) async {
    final records = getCachedRecords(cacheKey) ?? [];
    final recordId = record['id']?.toString();
    if (recordId == null) {
      await cacheRecords(cacheKey, [...records, record]);
      return;
    }

    final nextRecords = <Map<String, dynamic>>[];
    var replaced = false;
    for (final existing in records) {
      if (existing['id']?.toString() == recordId) {
        nextRecords.add(record);
        replaced = true;
      } else {
        nextRecords.add(existing);
      }
    }

    if (!replaced) {
      nextRecords.add(record);
    }

    await cacheRecords(cacheKey, nextRecords);
  }

  Future<void> removeCachedRecord(String cacheKey, String id) async {
    final records = getCachedRecords(cacheKey) ?? [];
    await cacheRecords(
      cacheKey,
      records.where((record) => record['id']?.toString() != id).toList(),
    );
  }

  Future<void> queueMutation(Map<String, dynamic> mutation) async {
    final mutationId = mutation['mutationId']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString();
    await _pendingMutationsBox.put(mutationId, {...mutation, 'mutationId': mutationId});
  }

  List<Map<String, dynamic>> getPendingMutations() {
    return _pendingMutationsBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> removePendingMutation(String mutationId) async {
    await _pendingMutationsBox.delete(mutationId);
  }

  Future<void> clearCache() async {
    await _productsBox.clear();
    await _entityBox.clear();
    await _pendingMutationsBox.clear();
  }
}

@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage();
}