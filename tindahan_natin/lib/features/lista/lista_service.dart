import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/lista/lista_entry.dart';

part 'lista_service.g.dart';

class ListaService {
  final Dio _dio;

  ListaService(this._dio);

  Future<ListaEntry> createListaEntry(Map<String, dynamic> data) async {
    final response = await _dio.post('/public/lista', data: data);
    return ListaEntry.fromJson(response.data);
  }

  Future<List<ListaEntry>> getListaEntries(String storeId) async {
    final response = await _dio.get('/lista', queryParameters: {'storeId': storeId});
    return (response.data as List).map((e) => ListaEntry.fromJson(e)).toList();
  }

  Future<List<ListaEntry>> getPublicListaEntries(String storeId) async {
    final response = await _dio.get('/public/lista', queryParameters: {'storeId': storeId});
    return (response.data as List).map((e) => ListaEntry.fromJson(e)).toList();
  }

  Future<void> deleteListaEntry(String id) async {
    await _dio.delete('/lista/$id');
  }

  Future<void> markAsPaid(String id) async {
    await _dio.put('/public/lista/$id/pay');
  }
}

@riverpod
ListaService listaService(Ref ref) {
  return ListaService(ref.watch(dioClientProvider));
}

@riverpod
Future<List<ListaEntry>> listaHistory(Ref ref, String storeId) {
  return ref.watch(listaServiceProvider).getListaEntries(storeId);
}

@riverpod
Future<List<ListaEntry>> publicListaHistory(Ref ref, String storeId) {
  return ref.watch(listaServiceProvider).getPublicListaEntries(storeId);
}
