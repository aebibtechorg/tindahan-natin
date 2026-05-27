// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreStats {

 double get totalSales; double get totalCredit; int get totalTransactions; List<DailyStat> get dailyPerformance; List<TopProduct> get topProducts;
/// Create a copy of StoreStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreStatsCopyWith<StoreStats> get copyWith => _$StoreStatsCopyWithImpl<StoreStats>(this as StoreStats, _$identity);

  /// Serializes this StoreStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreStats&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&const DeepCollectionEquality().equals(other.dailyPerformance, dailyPerformance)&&const DeepCollectionEquality().equals(other.topProducts, topProducts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,totalCredit,totalTransactions,const DeepCollectionEquality().hash(dailyPerformance),const DeepCollectionEquality().hash(topProducts));

@override
String toString() {
  return 'StoreStats(totalSales: $totalSales, totalCredit: $totalCredit, totalTransactions: $totalTransactions, dailyPerformance: $dailyPerformance, topProducts: $topProducts)';
}


}

/// @nodoc
abstract mixin class $StoreStatsCopyWith<$Res>  {
  factory $StoreStatsCopyWith(StoreStats value, $Res Function(StoreStats) _then) = _$StoreStatsCopyWithImpl;
@useResult
$Res call({
 double totalSales, double totalCredit, int totalTransactions, List<DailyStat> dailyPerformance, List<TopProduct> topProducts
});




}
/// @nodoc
class _$StoreStatsCopyWithImpl<$Res>
    implements $StoreStatsCopyWith<$Res> {
  _$StoreStatsCopyWithImpl(this._self, this._then);

  final StoreStats _self;
  final $Res Function(StoreStats) _then;

/// Create a copy of StoreStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSales = null,Object? totalCredit = null,Object? totalTransactions = null,Object? dailyPerformance = null,Object? topProducts = null,}) {
  return _then(_self.copyWith(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,dailyPerformance: null == dailyPerformance ? _self.dailyPerformance : dailyPerformance // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreStats].
extension StoreStatsPatterns on StoreStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreStats value)  $default,){
final _that = this;
switch (_that) {
case _StoreStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreStats value)?  $default,){
final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSales,  double totalCredit,  int totalTransactions,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.dailyPerformance,_that.topProducts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSales,  double totalCredit,  int totalTransactions,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts)  $default,) {final _that = this;
switch (_that) {
case _StoreStats():
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.dailyPerformance,_that.topProducts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSales,  double totalCredit,  int totalTransactions,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts)?  $default,) {final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.dailyPerformance,_that.topProducts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreStats implements StoreStats {
  const _StoreStats({required this.totalSales, required this.totalCredit, required this.totalTransactions, required final  List<DailyStat> dailyPerformance, required final  List<TopProduct> topProducts}): _dailyPerformance = dailyPerformance,_topProducts = topProducts;
  factory _StoreStats.fromJson(Map<String, dynamic> json) => _$StoreStatsFromJson(json);

@override final  double totalSales;
@override final  double totalCredit;
@override final  int totalTransactions;
 final  List<DailyStat> _dailyPerformance;
@override List<DailyStat> get dailyPerformance {
  if (_dailyPerformance is EqualUnmodifiableListView) return _dailyPerformance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyPerformance);
}

 final  List<TopProduct> _topProducts;
@override List<TopProduct> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}


/// Create a copy of StoreStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreStatsCopyWith<_StoreStats> get copyWith => __$StoreStatsCopyWithImpl<_StoreStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreStats&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&const DeepCollectionEquality().equals(other._dailyPerformance, _dailyPerformance)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,totalCredit,totalTransactions,const DeepCollectionEquality().hash(_dailyPerformance),const DeepCollectionEquality().hash(_topProducts));

@override
String toString() {
  return 'StoreStats(totalSales: $totalSales, totalCredit: $totalCredit, totalTransactions: $totalTransactions, dailyPerformance: $dailyPerformance, topProducts: $topProducts)';
}


}

/// @nodoc
abstract mixin class _$StoreStatsCopyWith<$Res> implements $StoreStatsCopyWith<$Res> {
  factory _$StoreStatsCopyWith(_StoreStats value, $Res Function(_StoreStats) _then) = __$StoreStatsCopyWithImpl;
@override @useResult
$Res call({
 double totalSales, double totalCredit, int totalTransactions, List<DailyStat> dailyPerformance, List<TopProduct> topProducts
});




}
/// @nodoc
class __$StoreStatsCopyWithImpl<$Res>
    implements _$StoreStatsCopyWith<$Res> {
  __$StoreStatsCopyWithImpl(this._self, this._then);

  final _StoreStats _self;
  final $Res Function(_StoreStats) _then;

/// Create a copy of StoreStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSales = null,Object? totalCredit = null,Object? totalTransactions = null,Object? dailyPerformance = null,Object? topProducts = null,}) {
  return _then(_StoreStats(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,dailyPerformance: null == dailyPerformance ? _self._dailyPerformance : dailyPerformance // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,
  ));
}


}


/// @nodoc
mixin _$DailyStat {

 DateTime get date; double get amount;
/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyStatCopyWith<DailyStat> get copyWith => _$DailyStatCopyWithImpl<DailyStat>(this as DailyStat, _$identity);

  /// Serializes this DailyStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyStat&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount);

@override
String toString() {
  return 'DailyStat(date: $date, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $DailyStatCopyWith<$Res>  {
  factory $DailyStatCopyWith(DailyStat value, $Res Function(DailyStat) _then) = _$DailyStatCopyWithImpl;
@useResult
$Res call({
 DateTime date, double amount
});




}
/// @nodoc
class _$DailyStatCopyWithImpl<$Res>
    implements $DailyStatCopyWith<$Res> {
  _$DailyStatCopyWithImpl(this._self, this._then);

  final DailyStat _self;
  final $Res Function(DailyStat) _then;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? amount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyStat].
extension DailyStatPatterns on DailyStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyStat value)  $default,){
final _that = this;
switch (_that) {
case _DailyStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyStat value)?  $default,){
final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double amount)  $default,) {final _that = this;
switch (_that) {
case _DailyStat():
return $default(_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that.date,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyStat implements DailyStat {
  const _DailyStat({required this.date, required this.amount});
  factory _DailyStat.fromJson(Map<String, dynamic> json) => _$DailyStatFromJson(json);

@override final  DateTime date;
@override final  double amount;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyStatCopyWith<_DailyStat> get copyWith => __$DailyStatCopyWithImpl<_DailyStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyStat&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount);

@override
String toString() {
  return 'DailyStat(date: $date, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$DailyStatCopyWith<$Res> implements $DailyStatCopyWith<$Res> {
  factory _$DailyStatCopyWith(_DailyStat value, $Res Function(_DailyStat) _then) = __$DailyStatCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double amount
});




}
/// @nodoc
class __$DailyStatCopyWithImpl<$Res>
    implements _$DailyStatCopyWith<$Res> {
  __$DailyStatCopyWithImpl(this._self, this._then);

  final _DailyStat _self;
  final $Res Function(_DailyStat) _then;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? amount = null,}) {
  return _then(_DailyStat(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TopProduct {

 String get productId; String get productName; int get quantitySold; double get totalRevenue;
/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductCopyWith<TopProduct> get copyWith => _$TopProductCopyWithImpl<TopProduct>(this as TopProduct, _$identity);

  /// Serializes this TopProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantitySold,totalRevenue);

@override
String toString() {
  return 'TopProduct(productId: $productId, productName: $productName, quantitySold: $quantitySold, totalRevenue: $totalRevenue)';
}


}

/// @nodoc
abstract mixin class $TopProductCopyWith<$Res>  {
  factory $TopProductCopyWith(TopProduct value, $Res Function(TopProduct) _then) = _$TopProductCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, int quantitySold, double totalRevenue
});




}
/// @nodoc
class _$TopProductCopyWithImpl<$Res>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._self, this._then);

  final TopProduct _self;
  final $Res Function(TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? quantitySold = null,Object? totalRevenue = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TopProduct].
extension TopProductPatterns on TopProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProduct value)  $default,){
final _that = this;
switch (_that) {
case _TopProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProduct value)?  $default,){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  int quantitySold,  double totalRevenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
return $default(_that.productId,_that.productName,_that.quantitySold,_that.totalRevenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  int quantitySold,  double totalRevenue)  $default,) {final _that = this;
switch (_that) {
case _TopProduct():
return $default(_that.productId,_that.productName,_that.quantitySold,_that.totalRevenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  int quantitySold,  double totalRevenue)?  $default,) {final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
return $default(_that.productId,_that.productName,_that.quantitySold,_that.totalRevenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopProduct implements TopProduct {
  const _TopProduct({required this.productId, required this.productName, required this.quantitySold, required this.totalRevenue});
  factory _TopProduct.fromJson(Map<String, dynamic> json) => _$TopProductFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  int quantitySold;
@override final  double totalRevenue;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductCopyWith<_TopProduct> get copyWith => __$TopProductCopyWithImpl<_TopProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantitySold,totalRevenue);

@override
String toString() {
  return 'TopProduct(productId: $productId, productName: $productName, quantitySold: $quantitySold, totalRevenue: $totalRevenue)';
}


}

/// @nodoc
abstract mixin class _$TopProductCopyWith<$Res> implements $TopProductCopyWith<$Res> {
  factory _$TopProductCopyWith(_TopProduct value, $Res Function(_TopProduct) _then) = __$TopProductCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, int quantitySold, double totalRevenue
});




}
/// @nodoc
class __$TopProductCopyWithImpl<$Res>
    implements _$TopProductCopyWith<$Res> {
  __$TopProductCopyWithImpl(this._self, this._then);

  final _TopProduct _self;
  final $Res Function(_TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? quantitySold = null,Object? totalRevenue = null,}) {
  return _then(_TopProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
