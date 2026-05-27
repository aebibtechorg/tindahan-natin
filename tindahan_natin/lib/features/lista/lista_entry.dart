import 'package:freezed_annotation/freezed_annotation.dart';

part 'lista_entry.freezed.dart';
part 'lista_entry.g.dart';

@freezed
abstract class ListaEntry with _$ListaEntry {
  const factory ListaEntry({
    required String id,
    required String storeId,
    required String staffName,
    String? customerName,
    required bool isCredit,
    required double totalAmount,
    required DateTime createdAt,
    required List<ListaItem> items,
  }) = _ListaEntry;

  factory ListaEntry.fromJson(Map<String, dynamic> json) => _$ListaEntryFromJson(json);
}

@freezed
abstract class ListaItem with _$ListaItem {
  const factory ListaItem({
    required String id,
    required String productId,
    required String productName,
    required int quantity,
    required double price,
  }) = _ListaItem;

  factory ListaItem.fromJson(Map<String, dynamic> json) => _$ListaItemFromJson(json);
}
