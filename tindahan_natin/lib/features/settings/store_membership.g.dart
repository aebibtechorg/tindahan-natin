// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreMembership _$StoreMembershipFromJson(Map<String, dynamic> json) =>
    _StoreMembership(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      storeSlug: json['storeSlug'] as String,
      role: json['role'] as String,
      inviteCode: json['inviteCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StoreMembershipToJson(_StoreMembership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'storeSlug': instance.storeSlug,
      'role': instance.role,
      'inviteCode': instance.inviteCode,
      'createdAt': instance.createdAt.toIso8601String(),
    };
