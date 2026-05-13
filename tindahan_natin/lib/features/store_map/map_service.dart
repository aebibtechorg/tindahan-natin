import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/store_map/shelf.dart';

part 'map_service.g.dart';

class MapService {
  final Dio _dio;

  MapService(this._dio);

  Future<List<Shelf>> getShelves(int storeId) async {
    final response = await _dio.get('/map/shelves', queryParameters: {'storeId': storeId});
    return (response.data as List).map((e) => Shelf.fromJson(e)).toList();
  }

  Future<Shelf> createShelf(Map<String, dynamic> data) async {
    final response = await _dio.post('/map/shelves', data: data);
    return Shelf.fromJson(response.data);
  }

  Future<void> updateShelf(int id, Map<String, dynamic> data) async {
    await _dio.put('/map/shelves/$id', data: data);
  }

  Future<void> deleteShelf(int id) async {
    await _dio.delete('/map/shelves/$id');
  }

  Future<List<ProductLocation>> getProductLocations(int storeId) async {
    final response = await _dio.get('/map/locations', queryParameters: {'storeId': storeId});
    return (response.data as List).map((e) => ProductLocation.fromJson(e)).toList();
  }

  Future<ProductLocation> createProductLocation(Map<String, dynamic> data) async {
    final response = await _dio.post('/map/locations', data: data);
    return ProductLocation.fromJson(response.data);
  }

  Future<void> deleteProductLocation(int id) async {
    await _dio.delete('/map/locations/$id');
  }
}

@riverpod
MapService mapService(Ref ref) {
  return MapService(ref.watch(dioClientProvider));
}

@riverpod
Future<List<Shelf>> shelves(Ref ref, int storeId) {
  return ref.watch(mapServiceProvider).getShelves(storeId);
}

@riverpod
Future<List<ProductLocation>> productLocations(Ref ref, int storeId) {
  return ref.watch(mapServiceProvider).getProductLocations(storeId);
}