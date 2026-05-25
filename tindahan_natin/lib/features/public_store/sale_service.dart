import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/public_store/sale.dart';

part 'sale_service.g.dart';

class SaleService {
  final Dio _dio;

  SaleService(this._dio);

  Future<List<Sale>> getSales(String storeId, {DateTime? from, DateTime? to}) async {
    final response = await _dio.get('/sales', queryParameters: {
      'storeId': storeId,
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
    });
    return (response.data as List).map((e) => Sale.fromJson(e)).toList();
  }

  Future<Sale> recordSale({
    required String storeId,
    String? productId,
    required String productName,
    required double priceAtSale,
    required int quantity,
    required double totalPrice,
    required bool isCredit,
    String? customerName,
  }) async {
    final response = await _dio.post('/sales', data: {
      'storeId': storeId,
      'productId': productId,
      'productName': productName,
      'priceAtSale': priceAtSale,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'isCredit': isCredit,
      'customerName': customerName,
    });
    return Sale.fromJson(response.data);
  }
}

@riverpod
SaleService saleService(Ref ref) {
  return SaleService(ref.watch(dioClientProvider));
}

@riverpod
Future<List<Sale>> salesList(Ref ref, String storeId, {DateTime? from, DateTime? to}) {
  return ref.watch(saleServiceProvider).getSales(storeId, from: from, to: to);
}
