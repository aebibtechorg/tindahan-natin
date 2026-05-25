// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sale {

 String get id; String get storeId; String? get productId; String get productName; double get priceAtSale; int get quantity; double get totalPrice; bool get isCredit; String? get customerName; String get soldById; String? get soldByName; DateTime get createdAt;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.priceAtSale, priceAtSale) || other.priceAtSale == priceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.soldById, soldById) || other.soldById == soldById)&&(identical(other.soldByName, soldByName) || other.soldByName == soldByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,productName,priceAtSale,quantity,totalPrice,isCredit,customerName,soldById,soldByName,createdAt);

@override
String toString() {
  return 'Sale(id: $id, storeId: $storeId, productId: $productId, productName: $productName, priceAtSale: $priceAtSale, quantity: $quantity, totalPrice: $totalPrice, isCredit: $isCredit, customerName: $customerName, soldById: $soldById, soldByName: $soldByName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, String? productId, String productName, double priceAtSale, int quantity, double totalPrice, bool isCredit, String? customerName, String soldById, String? soldByName, DateTime createdAt
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? productId = freezed,Object? productName = null,Object? priceAtSale = null,Object? quantity = null,Object? totalPrice = null,Object? isCredit = null,Object? customerName = freezed,Object? soldById = null,Object? soldByName = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,priceAtSale: null == priceAtSale ? _self.priceAtSale : priceAtSale // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,soldById: null == soldById ? _self.soldById : soldById // ignore: cast_nullable_to_non_nullable
as String,soldByName: freezed == soldByName ? _self.soldByName : soldByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  String? productId,  String productName,  double priceAtSale,  int quantity,  double totalPrice,  bool isCredit,  String? customerName,  String soldById,  String? soldByName,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.productName,_that.priceAtSale,_that.quantity,_that.totalPrice,_that.isCredit,_that.customerName,_that.soldById,_that.soldByName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  String? productId,  String productName,  double priceAtSale,  int quantity,  double totalPrice,  bool isCredit,  String? customerName,  String soldById,  String? soldByName,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.id,_that.storeId,_that.productId,_that.productName,_that.priceAtSale,_that.quantity,_that.totalPrice,_that.isCredit,_that.customerName,_that.soldById,_that.soldByName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  String? productId,  String productName,  double priceAtSale,  int quantity,  double totalPrice,  bool isCredit,  String? customerName,  String soldById,  String? soldByName,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.productName,_that.priceAtSale,_that.quantity,_that.totalPrice,_that.isCredit,_that.customerName,_that.soldById,_that.soldByName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sale implements Sale {
  const _Sale({required this.id, required this.storeId, this.productId, required this.productName, required this.priceAtSale, required this.quantity, required this.totalPrice, required this.isCredit, this.customerName, required this.soldById, this.soldByName, required this.createdAt});
  factory _Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  String? productId;
@override final  String productName;
@override final  double priceAtSale;
@override final  int quantity;
@override final  double totalPrice;
@override final  bool isCredit;
@override final  String? customerName;
@override final  String soldById;
@override final  String? soldByName;
@override final  DateTime createdAt;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.priceAtSale, priceAtSale) || other.priceAtSale == priceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.soldById, soldById) || other.soldById == soldById)&&(identical(other.soldByName, soldByName) || other.soldByName == soldByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,productName,priceAtSale,quantity,totalPrice,isCredit,customerName,soldById,soldByName,createdAt);

@override
String toString() {
  return 'Sale(id: $id, storeId: $storeId, productId: $productId, productName: $productName, priceAtSale: $priceAtSale, quantity: $quantity, totalPrice: $totalPrice, isCredit: $isCredit, customerName: $customerName, soldById: $soldById, soldByName: $soldByName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, String? productId, String productName, double priceAtSale, int quantity, double totalPrice, bool isCredit, String? customerName, String soldById, String? soldByName, DateTime createdAt
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? productId = freezed,Object? productName = null,Object? priceAtSale = null,Object? quantity = null,Object? totalPrice = null,Object? isCredit = null,Object? customerName = freezed,Object? soldById = null,Object? soldByName = freezed,Object? createdAt = null,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,priceAtSale: null == priceAtSale ? _self.priceAtSale : priceAtSale // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,soldById: null == soldById ? _self.soldById : soldById // ignore: cast_nullable_to_non_nullable
as String,soldByName: freezed == soldByName ? _self.soldByName : soldByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
