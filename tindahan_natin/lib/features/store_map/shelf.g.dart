// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Shelf _$ShelfFromJson(Map<String, dynamic> json) => _Shelf(
  id: json['id'] as String,
  name: json['name'] as String,
  storeId: json['storeId'] as String,
  x: (json['x'] as num?)?.toDouble() ?? 0.0,
  y: (json['y'] as num?)?.toDouble() ?? 0.0,
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ShelfToJson(_Shelf instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'storeId': instance.storeId,
  'x': instance.x,
  'y': instance.y,
  'rotation': instance.rotation,
};

_ProductLocation _$ProductLocationFromJson(Map<String, dynamic> json) =>
    _ProductLocation(
      id: json['id'] as String,
      productId: json['productId'] as String,
      shelfId: json['shelfId'] as String,
      position: json['position'] as String,
    );

Map<String, dynamic> _$ProductLocationToJson(_ProductLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'shelfId': instance.shelfId,
      'position': instance.position,
    };
