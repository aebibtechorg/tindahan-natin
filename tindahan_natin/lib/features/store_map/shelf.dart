import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelf.freezed.dart';
part 'shelf.g.dart';

@freezed
abstract class Shelf with _$Shelf {
  const factory Shelf({
    required String id,
    required String name,
    required String storeId,
    @Default(0.0) double x,
    @Default(0.0) double y,
  }) = _Shelf;

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);
}

@freezed
abstract class ProductLocation with _$ProductLocation {
  const factory ProductLocation({
    required String id,
    required String productId,
    required String shelfId,
    required String position,
  }) = _ProductLocation;

  factory ProductLocation.fromJson(Map<String, dynamic> json) => _$ProductLocationFromJson(json);
}