import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage.g.dart';

class LocalStorage {
  final Box _productsBox = Hive.box('products_cache');
  final Box _settingsBox = Hive.box('settings');

  Future<void> cacheProducts(int storeId, List<Map<String, dynamic>> products) async {
    await _productsBox.put('products_$storeId', products);
  }

  List<Map<String, dynamic>>? getCachedProducts(int storeId) {
    final data = _productsBox.get('products_$storeId');
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(
      (data as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  Future<void> clearCache() async {
    await _productsBox.clear();
  }
}

@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage();
}