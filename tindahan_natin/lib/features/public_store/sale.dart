import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    required String id,
    required String storeId,
    String? productId,
    required String productName,
    required double priceAtSale,
    required int quantity,
    required double totalPrice,
    required bool isCredit,
    String? customerName,
    required String soldById,
    String? soldByName,
    required DateTime createdAt,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
