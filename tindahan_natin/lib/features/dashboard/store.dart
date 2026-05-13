import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
abstract class Store with _$Store {
  const factory Store({
    required int id,
    required String name,
    required String slug,
    required String ownerId,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}