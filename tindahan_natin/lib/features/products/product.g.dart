// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  barcode: json['barcode'] as String?,
  storeId: (json['storeId'] as num).toInt(),
  shelfId: (json['shelfId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'quantity': instance.quantity,
  'categoryId': instance.categoryId,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'barcode': instance.barcode,
  'storeId': instance.storeId,
  'shelfId': instance.shelfId,
};
