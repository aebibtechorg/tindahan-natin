import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_membership.freezed.dart';
part 'store_membership.g.dart';

@freezed
abstract class StoreMembership with _$StoreMembership {
  const factory StoreMembership({
    required String id,
    required String storeId,
    required String storeName,
    required String storeSlug,
    required String role,
    String? inviteCode,
    required DateTime createdAt,
  }) = _StoreMembership;

  factory StoreMembership.fromJson(Map<String, dynamic> json) => _$StoreMembershipFromJson(json);
}
