// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreMembership {

 String get id; String get storeId; String get storeName; String get storeSlug; String get role; String? get inviteCode; DateTime get createdAt;
/// Create a copy of StoreMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreMembershipCopyWith<StoreMembership> get copyWith => _$StoreMembershipCopyWithImpl<StoreMembership>(this as StoreMembership, _$identity);

  /// Serializes this StoreMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeSlug, storeSlug) || other.storeSlug == storeSlug)&&(identical(other.role, role) || other.role == role)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,storeSlug,role,inviteCode,createdAt);

@override
String toString() {
  return 'StoreMembership(id: $id, storeId: $storeId, storeName: $storeName, storeSlug: $storeSlug, role: $role, inviteCode: $inviteCode, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StoreMembershipCopyWith<$Res>  {
  factory $StoreMembershipCopyWith(StoreMembership value, $Res Function(StoreMembership) _then) = _$StoreMembershipCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, String storeName, String storeSlug, String role, String? inviteCode, DateTime createdAt
});




}
/// @nodoc
class _$StoreMembershipCopyWithImpl<$Res>
    implements $StoreMembershipCopyWith<$Res> {
  _$StoreMembershipCopyWithImpl(this._self, this._then);

  final StoreMembership _self;
  final $Res Function(StoreMembership) _then;

/// Create a copy of StoreMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? storeName = null,Object? storeSlug = null,Object? role = null,Object? inviteCode = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeSlug: null == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreMembership].
extension StoreMembershipPatterns on StoreMembership {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreMembership() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreMembership value)  $default,){
final _that = this;
switch (_that) {
case _StoreMembership():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreMembership value)?  $default,){
final _that = this;
switch (_that) {
case _StoreMembership() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  String storeName,  String storeSlug,  String role,  String? inviteCode,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreMembership() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.storeSlug,_that.role,_that.inviteCode,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  String storeName,  String storeSlug,  String role,  String? inviteCode,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StoreMembership():
return $default(_that.id,_that.storeId,_that.storeName,_that.storeSlug,_that.role,_that.inviteCode,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  String storeName,  String storeSlug,  String role,  String? inviteCode,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StoreMembership() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.storeSlug,_that.role,_that.inviteCode,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreMembership implements StoreMembership {
  const _StoreMembership({required this.id, required this.storeId, required this.storeName, required this.storeSlug, required this.role, this.inviteCode, required this.createdAt});
  factory _StoreMembership.fromJson(Map<String, dynamic> json) => _$StoreMembershipFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  String storeName;
@override final  String storeSlug;
@override final  String role;
@override final  String? inviteCode;
@override final  DateTime createdAt;

/// Create a copy of StoreMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreMembershipCopyWith<_StoreMembership> get copyWith => __$StoreMembershipCopyWithImpl<_StoreMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeSlug, storeSlug) || other.storeSlug == storeSlug)&&(identical(other.role, role) || other.role == role)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,storeSlug,role,inviteCode,createdAt);

@override
String toString() {
  return 'StoreMembership(id: $id, storeId: $storeId, storeName: $storeName, storeSlug: $storeSlug, role: $role, inviteCode: $inviteCode, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StoreMembershipCopyWith<$Res> implements $StoreMembershipCopyWith<$Res> {
  factory _$StoreMembershipCopyWith(_StoreMembership value, $Res Function(_StoreMembership) _then) = __$StoreMembershipCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, String storeName, String storeSlug, String role, String? inviteCode, DateTime createdAt
});




}
/// @nodoc
class __$StoreMembershipCopyWithImpl<$Res>
    implements _$StoreMembershipCopyWith<$Res> {
  __$StoreMembershipCopyWithImpl(this._self, this._then);

  final _StoreMembership _self;
  final $Res Function(_StoreMembership) _then;

/// Create a copy of StoreMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? storeName = null,Object? storeSlug = null,Object? role = null,Object? inviteCode = freezed,Object? createdAt = null,}) {
  return _then(_StoreMembership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeSlug: null == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
