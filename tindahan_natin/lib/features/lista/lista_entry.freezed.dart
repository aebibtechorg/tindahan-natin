// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lista_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListaEntry {

 String get id; String get storeId; String get staffName; String? get customerName; bool get isCredit; double get totalAmount; DateTime get createdAt; List<ListaItem> get items;
/// Create a copy of ListaEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListaEntryCopyWith<ListaEntry> get copyWith => _$ListaEntryCopyWithImpl<ListaEntry>(this as ListaEntry, _$identity);

  /// Serializes this ListaEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListaEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.staffName, staffName) || other.staffName == staffName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,staffName,customerName,isCredit,totalAmount,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ListaEntry(id: $id, storeId: $storeId, staffName: $staffName, customerName: $customerName, isCredit: $isCredit, totalAmount: $totalAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $ListaEntryCopyWith<$Res>  {
  factory $ListaEntryCopyWith(ListaEntry value, $Res Function(ListaEntry) _then) = _$ListaEntryCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, String staffName, String? customerName, bool isCredit, double totalAmount, DateTime createdAt, List<ListaItem> items
});




}
/// @nodoc
class _$ListaEntryCopyWithImpl<$Res>
    implements $ListaEntryCopyWith<$Res> {
  _$ListaEntryCopyWithImpl(this._self, this._then);

  final ListaEntry _self;
  final $Res Function(ListaEntry) _then;

/// Create a copy of ListaEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? staffName = null,Object? customerName = freezed,Object? isCredit = null,Object? totalAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,staffName: null == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ListaItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListaEntry].
extension ListaEntryPatterns on ListaEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListaEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListaEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListaEntry value)  $default,){
final _that = this;
switch (_that) {
case _ListaEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListaEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ListaEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  List<ListaItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListaEntry() when $default != null:
return $default(_that.id,_that.storeId,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  List<ListaItem> items)  $default,) {final _that = this;
switch (_that) {
case _ListaEntry():
return $default(_that.id,_that.storeId,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  List<ListaItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ListaEntry() when $default != null:
return $default(_that.id,_that.storeId,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListaEntry implements ListaEntry {
  const _ListaEntry({required this.id, required this.storeId, required this.staffName, this.customerName, required this.isCredit, required this.totalAmount, required this.createdAt, required final  List<ListaItem> items}): _items = items;
  factory _ListaEntry.fromJson(Map<String, dynamic> json) => _$ListaEntryFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  String staffName;
@override final  String? customerName;
@override final  bool isCredit;
@override final  double totalAmount;
@override final  DateTime createdAt;
 final  List<ListaItem> _items;
@override List<ListaItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ListaEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListaEntryCopyWith<_ListaEntry> get copyWith => __$ListaEntryCopyWithImpl<_ListaEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListaEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListaEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.staffName, staffName) || other.staffName == staffName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,staffName,customerName,isCredit,totalAmount,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ListaEntry(id: $id, storeId: $storeId, staffName: $staffName, customerName: $customerName, isCredit: $isCredit, totalAmount: $totalAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ListaEntryCopyWith<$Res> implements $ListaEntryCopyWith<$Res> {
  factory _$ListaEntryCopyWith(_ListaEntry value, $Res Function(_ListaEntry) _then) = __$ListaEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, String staffName, String? customerName, bool isCredit, double totalAmount, DateTime createdAt, List<ListaItem> items
});




}
/// @nodoc
class __$ListaEntryCopyWithImpl<$Res>
    implements _$ListaEntryCopyWith<$Res> {
  __$ListaEntryCopyWithImpl(this._self, this._then);

  final _ListaEntry _self;
  final $Res Function(_ListaEntry) _then;

/// Create a copy of ListaEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? staffName = null,Object? customerName = freezed,Object? isCredit = null,Object? totalAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_ListaEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,staffName: null == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ListaItem>,
  ));
}


}


/// @nodoc
mixin _$ListaItem {

 String get id; String get productId; String get productName; int get quantity; double get price;
/// Create a copy of ListaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListaItemCopyWith<ListaItem> get copyWith => _$ListaItemCopyWithImpl<ListaItem>(this as ListaItem, _$identity);

  /// Serializes this ListaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListaItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,price);

@override
String toString() {
  return 'ListaItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, price: $price)';
}


}

/// @nodoc
abstract mixin class $ListaItemCopyWith<$Res>  {
  factory $ListaItemCopyWith(ListaItem value, $Res Function(ListaItem) _then) = _$ListaItemCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String productName, int quantity, double price
});




}
/// @nodoc
class _$ListaItemCopyWithImpl<$Res>
    implements $ListaItemCopyWith<$Res> {
  _$ListaItemCopyWithImpl(this._self, this._then);

  final ListaItem _self;
  final $Res Function(ListaItem) _then;

/// Create a copy of ListaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ListaItem].
extension ListaItemPatterns on ListaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListaItem value)  $default,){
final _that = this;
switch (_that) {
case _ListaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListaItem value)?  $default,){
final _that = this;
switch (_that) {
case _ListaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String productName,  int quantity,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListaItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String productName,  int quantity,  double price)  $default,) {final _that = this;
switch (_that) {
case _ListaItem():
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String productName,  int quantity,  double price)?  $default,) {final _that = this;
switch (_that) {
case _ListaItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListaItem implements ListaItem {
  const _ListaItem({required this.id, required this.productId, required this.productName, required this.quantity, required this.price});
  factory _ListaItem.fromJson(Map<String, dynamic> json) => _$ListaItemFromJson(json);

@override final  String id;
@override final  String productId;
@override final  String productName;
@override final  int quantity;
@override final  double price;

/// Create a copy of ListaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListaItemCopyWith<_ListaItem> get copyWith => __$ListaItemCopyWithImpl<_ListaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListaItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListaItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,price);

@override
String toString() {
  return 'ListaItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ListaItemCopyWith<$Res> implements $ListaItemCopyWith<$Res> {
  factory _$ListaItemCopyWith(_ListaItem value, $Res Function(_ListaItem) _then) = __$ListaItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String productName, int quantity, double price
});




}
/// @nodoc
class __$ListaItemCopyWithImpl<$Res>
    implements _$ListaItemCopyWith<$Res> {
  __$ListaItemCopyWithImpl(this._self, this._then);

  final _ListaItem _self;
  final $Res Function(_ListaItem) _then;

/// Create a copy of ListaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? price = null,}) {
  return _then(_ListaItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
