import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelf.freezed.dart';
part 'shelf.g.dart';

@freezed
abstract class Shelf with _$Shelf {
  const factory Shelf({
    required int id,
    required String name,
    required int storeId,
    @Default(0.0) double x,
    @Default(0.0) double y,
  }) = _Shelf;

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);
}

@freezed
abstract class ProductLocation with _$ProductLocation {
  const factory ProductLocation({
    required int id,
    required int productId,
    required int shelfId,
    required String position,
  }) = _ProductLocation;

  factory ProductLocation.fromJson(Map<String, dynamic> json) => _$ProductLocationFromJson(json);
}