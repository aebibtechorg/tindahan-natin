// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sale _$SaleFromJson(Map<String, dynamic> json) => _Sale(
  id: json['id'] as String,
  storeId: json['storeId'] as String,
  productId: json['productId'] as String?,
  productName: json['productName'] as String,
  priceAtSale: (json['priceAtSale'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
  isCredit: json['isCredit'] as bool,
  customerName: json['customerName'] as String?,
  soldById: json['soldById'] as String,
  soldByName: json['soldByName'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SaleToJson(_Sale instance) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'productId': instance.productId,
  'productName': instance.productName,
  'priceAtSale': instance.priceAtSale,
  'quantity': instance.quantity,
  'totalPrice': instance.totalPrice,
  'isCredit': instance.isCredit,
  'customerName': instance.customerName,
  'soldById': instance.soldById,
  'soldByName': instance.soldByName,
  'createdAt': instance.createdAt.toIso8601String(),
};
