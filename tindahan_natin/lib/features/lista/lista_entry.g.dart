// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListaEntry _$ListaEntryFromJson(Map<String, dynamic> json) => _ListaEntry(
  id: json['id'] as String,
  storeId: json['storeId'] as String,
  staffName: json['staffName'] as String,
  customerName: json['customerName'] as String?,
  isCredit: json['isCredit'] as bool,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => ListaItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListaEntryToJson(_ListaEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'staffName': instance.staffName,
      'customerName': instance.customerName,
      'isCredit': instance.isCredit,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'items': instance.items,
    };

_ListaItem _$ListaItemFromJson(Map<String, dynamic> json) => _ListaItem(
  id: json['id'] as String,
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$ListaItemToJson(_ListaItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'price': instance.price,
    };
