// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Shelf {

 int get id; String get name; int get storeId; double get x; double get y;
/// Create a copy of Shelf
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfCopyWith<Shelf> get copyWith => _$ShelfCopyWithImpl<Shelf>(this as Shelf, _$identity);

  /// Serializes this Shelf to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shelf&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,storeId,x,y);

@override
String toString() {
  return 'Shelf(id: $id, name: $name, storeId: $storeId, x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class $ShelfCopyWith<$Res>  {
  factory $ShelfCopyWith(Shelf value, $Res Function(Shelf) _then) = _$ShelfCopyWithImpl;
@useResult
$Res call({
 int id, String name, int storeId, double x, double y
});




}
/// @nodoc
class _$ShelfCopyWithImpl<$Res>
    implements $ShelfCopyWith<$Res> {
  _$ShelfCopyWithImpl(this._self, this._then);

  final Shelf _self;
  final $Res Function(Shelf) _then;

/// Create a copy of Shelf
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? storeId = null,Object? x = null,Object? y = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Shelf].
extension ShelfPatterns on Shelf {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shelf value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shelf() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shelf value)  $default,){
final _that = this;
switch (_that) {
case _Shelf():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shelf value)?  $default,){
final _that = this;
switch (_that) {
case _Shelf() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int storeId,  double x,  double y)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shelf() when $default != null:
return $default(_that.id,_that.name,_that.storeId,_that.x,_that.y);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int storeId,  double x,  double y)  $default,) {final _that = this;
switch (_that) {
case _Shelf():
return $default(_that.id,_that.name,_that.storeId,_that.x,_that.y);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int storeId,  double x,  double y)?  $default,) {final _that = this;
switch (_that) {
case _Shelf() when $default != null:
return $default(_that.id,_that.name,_that.storeId,_that.x,_that.y);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shelf implements Shelf {
  const _Shelf({required this.id, required this.name, required this.storeId, this.x = 0.0, this.y = 0.0});
  factory _Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);

@override final  int id;
@override final  String name;
@override final  int storeId;
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;

/// Create a copy of Shelf
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelfCopyWith<_Shelf> get copyWith => __$ShelfCopyWithImpl<_Shelf>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShelfToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shelf&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,storeId,x,y);

@override
String toString() {
  return 'Shelf(id: $id, name: $name, storeId: $storeId, x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$ShelfCopyWith<$Res> implements $ShelfCopyWith<$Res> {
  factory _$ShelfCopyWith(_Shelf value, $Res Function(_Shelf) _then) = __$ShelfCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int storeId, double x, double y
});




}
/// @nodoc
class __$ShelfCopyWithImpl<$Res>
    implements _$ShelfCopyWith<$Res> {
  __$ShelfCopyWithImpl(this._self, this._then);

  final _Shelf _self;
  final $Res Function(_Shelf) _then;

/// Create a copy of Shelf
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? storeId = null,Object? x = null,Object? y = null,}) {
  return _then(_Shelf(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ProductLocation {

 int get id; int get productId; int get shelfId; String get position;
/// Create a copy of ProductLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductLocationCopyWith<ProductLocation> get copyWith => _$ProductLocationCopyWithImpl<ProductLocation>(this as ProductLocation, _$identity);

  /// Serializes this ProductLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.shelfId, shelfId) || other.shelfId == shelfId)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,shelfId,position);

@override
String toString() {
  return 'ProductLocation(id: $id, productId: $productId, shelfId: $shelfId, position: $position)';
}


}

/// @nodoc
abstract mixin class $ProductLocationCopyWith<$Res>  {
  factory $ProductLocationCopyWith(ProductLocation value, $Res Function(ProductLocation) _then) = _$ProductLocationCopyWithImpl;
@useResult
$Res call({
 int id, int productId, int shelfId, String position
});




}
/// @nodoc
class _$ProductLocationCopyWithImpl<$Res>
    implements $ProductLocationCopyWith<$Res> {
  _$ProductLocationCopyWithImpl(this._self, this._then);

  final ProductLocation _self;
  final $Res Function(ProductLocation) _then;

/// Create a copy of ProductLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? shelfId = null,Object? position = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,shelfId: null == shelfId ? _self.shelfId : shelfId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductLocation].
extension ProductLocationPatterns on ProductLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductLocation value)  $default,){
final _that = this;
switch (_that) {
case _ProductLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductLocation value)?  $default,){
final _that = this;
switch (_that) {
case _ProductLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int productId,  int shelfId,  String position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductLocation() when $default != null:
return $default(_that.id,_that.productId,_that.shelfId,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int productId,  int shelfId,  String position)  $default,) {final _that = this;
switch (_that) {
case _ProductLocation():
return $default(_that.id,_that.productId,_that.shelfId,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int productId,  int shelfId,  String position)?  $default,) {final _that = this;
switch (_that) {
case _ProductLocation() when $default != null:
return $default(_that.id,_that.productId,_that.shelfId,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductLocation implements ProductLocation {
  const _ProductLocation({required this.id, required this.productId, required this.shelfId, required this.position});
  factory _ProductLocation.fromJson(Map<String, dynamic> json) => _$ProductLocationFromJson(json);

@override final  int id;
@override final  int productId;
@override final  int shelfId;
@override final  String position;

/// Create a copy of ProductLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductLocationCopyWith<_ProductLocation> get copyWith => __$ProductLocationCopyWithImpl<_ProductLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.shelfId, shelfId) || other.shelfId == shelfId)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,shelfId,position);

@override
String toString() {
  return 'ProductLocation(id: $id, productId: $productId, shelfId: $shelfId, position: $position)';
}


}

/// @nodoc
abstract mixin class _$ProductLocationCopyWith<$Res> implements $ProductLocationCopyWith<$Res> {
  factory _$ProductLocationCopyWith(_ProductLocation value, $Res Function(_ProductLocation) _then) = __$ProductLocationCopyWithImpl;
@override @useResult
$Res call({
 int id, int productId, int shelfId, String position
});




}
/// @nodoc
class __$ProductLocationCopyWithImpl<$Res>
    implements _$ProductLocationCopyWith<$Res> {
  __$ProductLocationCopyWithImpl(this._self, this._then);

  final _ProductLocation _self;
  final $Res Function(_ProductLocation) _then;

/// Create a copy of ProductLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? shelfId = null,Object? position = null,}) {
  return _then(_ProductLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,shelfId: null == shelfId ? _self.shelfId : shelfId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
