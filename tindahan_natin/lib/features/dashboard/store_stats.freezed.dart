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

 double get totalSales; double get totalCredit; int get totalTransactions; double get performanceChange; List<DailyStat> get dailyPerformance; List<TopProduct> get topProducts; List<ProductAlert> get alerts; double get totalInventoryValue; List<ActiveCategory> get mostActiveCategories; List<RecentTransaction> get recentTransactions; List<WeeklyStat> get weeklyPerformance;
/// Create a copy of StoreStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreStatsCopyWith<StoreStats> get copyWith => _$StoreStatsCopyWithImpl<StoreStats>(this as StoreStats, _$identity);

  /// Serializes this StoreStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreStats&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.performanceChange, performanceChange) || other.performanceChange == performanceChange)&&const DeepCollectionEquality().equals(other.dailyPerformance, dailyPerformance)&&const DeepCollectionEquality().equals(other.topProducts, topProducts)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&(identical(other.totalInventoryValue, totalInventoryValue) || other.totalInventoryValue == totalInventoryValue)&&const DeepCollectionEquality().equals(other.mostActiveCategories, mostActiveCategories)&&const DeepCollectionEquality().equals(other.recentTransactions, recentTransactions)&&const DeepCollectionEquality().equals(other.weeklyPerformance, weeklyPerformance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,totalCredit,totalTransactions,performanceChange,const DeepCollectionEquality().hash(dailyPerformance),const DeepCollectionEquality().hash(topProducts),const DeepCollectionEquality().hash(alerts),totalInventoryValue,const DeepCollectionEquality().hash(mostActiveCategories),const DeepCollectionEquality().hash(recentTransactions),const DeepCollectionEquality().hash(weeklyPerformance));

@override
String toString() {
  return 'StoreStats(totalSales: $totalSales, totalCredit: $totalCredit, totalTransactions: $totalTransactions, performanceChange: $performanceChange, dailyPerformance: $dailyPerformance, topProducts: $topProducts, alerts: $alerts, totalInventoryValue: $totalInventoryValue, mostActiveCategories: $mostActiveCategories, recentTransactions: $recentTransactions, weeklyPerformance: $weeklyPerformance)';
}


}

/// @nodoc
abstract mixin class $StoreStatsCopyWith<$Res>  {
  factory $StoreStatsCopyWith(StoreStats value, $Res Function(StoreStats) _then) = _$StoreStatsCopyWithImpl;
@useResult
$Res call({
 double totalSales, double totalCredit, int totalTransactions, double performanceChange, List<DailyStat> dailyPerformance, List<TopProduct> topProducts, List<ProductAlert> alerts, double totalInventoryValue, List<ActiveCategory> mostActiveCategories, List<RecentTransaction> recentTransactions, List<WeeklyStat> weeklyPerformance
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
@pragma('vm:prefer-inline') @override $Res call({Object? totalSales = null,Object? totalCredit = null,Object? totalTransactions = null,Object? performanceChange = null,Object? dailyPerformance = null,Object? topProducts = null,Object? alerts = null,Object? totalInventoryValue = null,Object? mostActiveCategories = null,Object? recentTransactions = null,Object? weeklyPerformance = null,}) {
  return _then(_self.copyWith(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,performanceChange: null == performanceChange ? _self.performanceChange : performanceChange // ignore: cast_nullable_to_non_nullable
as double,dailyPerformance: null == dailyPerformance ? _self.dailyPerformance : dailyPerformance // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<ProductAlert>,totalInventoryValue: null == totalInventoryValue ? _self.totalInventoryValue : totalInventoryValue // ignore: cast_nullable_to_non_nullable
as double,mostActiveCategories: null == mostActiveCategories ? _self.mostActiveCategories : mostActiveCategories // ignore: cast_nullable_to_non_nullable
as List<ActiveCategory>,recentTransactions: null == recentTransactions ? _self.recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<RecentTransaction>,weeklyPerformance: null == weeklyPerformance ? _self.weeklyPerformance : weeklyPerformance // ignore: cast_nullable_to_non_nullable
as List<WeeklyStat>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSales,  double totalCredit,  int totalTransactions,  double performanceChange,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts,  List<ProductAlert> alerts,  double totalInventoryValue,  List<ActiveCategory> mostActiveCategories,  List<RecentTransaction> recentTransactions,  List<WeeklyStat> weeklyPerformance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.performanceChange,_that.dailyPerformance,_that.topProducts,_that.alerts,_that.totalInventoryValue,_that.mostActiveCategories,_that.recentTransactions,_that.weeklyPerformance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSales,  double totalCredit,  int totalTransactions,  double performanceChange,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts,  List<ProductAlert> alerts,  double totalInventoryValue,  List<ActiveCategory> mostActiveCategories,  List<RecentTransaction> recentTransactions,  List<WeeklyStat> weeklyPerformance)  $default,) {final _that = this;
switch (_that) {
case _StoreStats():
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.performanceChange,_that.dailyPerformance,_that.topProducts,_that.alerts,_that.totalInventoryValue,_that.mostActiveCategories,_that.recentTransactions,_that.weeklyPerformance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSales,  double totalCredit,  int totalTransactions,  double performanceChange,  List<DailyStat> dailyPerformance,  List<TopProduct> topProducts,  List<ProductAlert> alerts,  double totalInventoryValue,  List<ActiveCategory> mostActiveCategories,  List<RecentTransaction> recentTransactions,  List<WeeklyStat> weeklyPerformance)?  $default,) {final _that = this;
switch (_that) {
case _StoreStats() when $default != null:
return $default(_that.totalSales,_that.totalCredit,_that.totalTransactions,_that.performanceChange,_that.dailyPerformance,_that.topProducts,_that.alerts,_that.totalInventoryValue,_that.mostActiveCategories,_that.recentTransactions,_that.weeklyPerformance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreStats implements StoreStats {
  const _StoreStats({required this.totalSales, required this.totalCredit, required this.totalTransactions, required this.performanceChange, required final  List<DailyStat> dailyPerformance, required final  List<TopProduct> topProducts, final  List<ProductAlert> alerts = const [], required this.totalInventoryValue, required final  List<ActiveCategory> mostActiveCategories, required final  List<RecentTransaction> recentTransactions, required final  List<WeeklyStat> weeklyPerformance}): _dailyPerformance = dailyPerformance,_topProducts = topProducts,_alerts = alerts,_mostActiveCategories = mostActiveCategories,_recentTransactions = recentTransactions,_weeklyPerformance = weeklyPerformance;
  factory _StoreStats.fromJson(Map<String, dynamic> json) => _$StoreStatsFromJson(json);

@override final  double totalSales;
@override final  double totalCredit;
@override final  int totalTransactions;
@override final  double performanceChange;
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

 final  List<ProductAlert> _alerts;
@override@JsonKey() List<ProductAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

@override final  double totalInventoryValue;
 final  List<ActiveCategory> _mostActiveCategories;
@override List<ActiveCategory> get mostActiveCategories {
  if (_mostActiveCategories is EqualUnmodifiableListView) return _mostActiveCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostActiveCategories);
}

 final  List<RecentTransaction> _recentTransactions;
@override List<RecentTransaction> get recentTransactions {
  if (_recentTransactions is EqualUnmodifiableListView) return _recentTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTransactions);
}

 final  List<WeeklyStat> _weeklyPerformance;
@override List<WeeklyStat> get weeklyPerformance {
  if (_weeklyPerformance is EqualUnmodifiableListView) return _weeklyPerformance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyPerformance);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreStats&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.performanceChange, performanceChange) || other.performanceChange == performanceChange)&&const DeepCollectionEquality().equals(other._dailyPerformance, _dailyPerformance)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&(identical(other.totalInventoryValue, totalInventoryValue) || other.totalInventoryValue == totalInventoryValue)&&const DeepCollectionEquality().equals(other._mostActiveCategories, _mostActiveCategories)&&const DeepCollectionEquality().equals(other._recentTransactions, _recentTransactions)&&const DeepCollectionEquality().equals(other._weeklyPerformance, _weeklyPerformance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,totalCredit,totalTransactions,performanceChange,const DeepCollectionEquality().hash(_dailyPerformance),const DeepCollectionEquality().hash(_topProducts),const DeepCollectionEquality().hash(_alerts),totalInventoryValue,const DeepCollectionEquality().hash(_mostActiveCategories),const DeepCollectionEquality().hash(_recentTransactions),const DeepCollectionEquality().hash(_weeklyPerformance));

@override
String toString() {
  return 'StoreStats(totalSales: $totalSales, totalCredit: $totalCredit, totalTransactions: $totalTransactions, performanceChange: $performanceChange, dailyPerformance: $dailyPerformance, topProducts: $topProducts, alerts: $alerts, totalInventoryValue: $totalInventoryValue, mostActiveCategories: $mostActiveCategories, recentTransactions: $recentTransactions, weeklyPerformance: $weeklyPerformance)';
}


}

/// @nodoc
abstract mixin class _$StoreStatsCopyWith<$Res> implements $StoreStatsCopyWith<$Res> {
  factory _$StoreStatsCopyWith(_StoreStats value, $Res Function(_StoreStats) _then) = __$StoreStatsCopyWithImpl;
@override @useResult
$Res call({
 double totalSales, double totalCredit, int totalTransactions, double performanceChange, List<DailyStat> dailyPerformance, List<TopProduct> topProducts, List<ProductAlert> alerts, double totalInventoryValue, List<ActiveCategory> mostActiveCategories, List<RecentTransaction> recentTransactions, List<WeeklyStat> weeklyPerformance
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
@override @pragma('vm:prefer-inline') $Res call({Object? totalSales = null,Object? totalCredit = null,Object? totalTransactions = null,Object? performanceChange = null,Object? dailyPerformance = null,Object? topProducts = null,Object? alerts = null,Object? totalInventoryValue = null,Object? mostActiveCategories = null,Object? recentTransactions = null,Object? weeklyPerformance = null,}) {
  return _then(_StoreStats(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,performanceChange: null == performanceChange ? _self.performanceChange : performanceChange // ignore: cast_nullable_to_non_nullable
as double,dailyPerformance: null == dailyPerformance ? _self._dailyPerformance : dailyPerformance // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<ProductAlert>,totalInventoryValue: null == totalInventoryValue ? _self.totalInventoryValue : totalInventoryValue // ignore: cast_nullable_to_non_nullable
as double,mostActiveCategories: null == mostActiveCategories ? _self._mostActiveCategories : mostActiveCategories // ignore: cast_nullable_to_non_nullable
as List<ActiveCategory>,recentTransactions: null == recentTransactions ? _self._recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<RecentTransaction>,weeklyPerformance: null == weeklyPerformance ? _self._weeklyPerformance : weeklyPerformance // ignore: cast_nullable_to_non_nullable
as List<WeeklyStat>,
  ));
}


}


/// @nodoc
mixin _$ActiveCategory {

 String get categoryId; String get categoryName; int get itemsSold; double get revenue;
/// Create a copy of ActiveCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveCategoryCopyWith<ActiveCategory> get copyWith => _$ActiveCategoryCopyWithImpl<ActiveCategory>(this as ActiveCategory, _$identity);

  /// Serializes this ActiveCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,itemsSold,revenue);

@override
String toString() {
  return 'ActiveCategory(categoryId: $categoryId, categoryName: $categoryName, itemsSold: $itemsSold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class $ActiveCategoryCopyWith<$Res>  {
  factory $ActiveCategoryCopyWith(ActiveCategory value, $Res Function(ActiveCategory) _then) = _$ActiveCategoryCopyWithImpl;
@useResult
$Res call({
 String categoryId, String categoryName, int itemsSold, double revenue
});




}
/// @nodoc
class _$ActiveCategoryCopyWithImpl<$Res>
    implements $ActiveCategoryCopyWith<$Res> {
  _$ActiveCategoryCopyWithImpl(this._self, this._then);

  final ActiveCategory _self;
  final $Res Function(ActiveCategory) _then;

/// Create a copy of ActiveCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? itemsSold = null,Object? revenue = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveCategory].
extension ActiveCategoryPatterns on ActiveCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveCategory value)  $default,){
final _that = this;
switch (_that) {
case _ActiveCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveCategory value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String categoryName,  int itemsSold,  double revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveCategory() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.itemsSold,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String categoryName,  int itemsSold,  double revenue)  $default,) {final _that = this;
switch (_that) {
case _ActiveCategory():
return $default(_that.categoryId,_that.categoryName,_that.itemsSold,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String categoryName,  int itemsSold,  double revenue)?  $default,) {final _that = this;
switch (_that) {
case _ActiveCategory() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.itemsSold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveCategory implements ActiveCategory {
  const _ActiveCategory({required this.categoryId, required this.categoryName, required this.itemsSold, required this.revenue});
  factory _ActiveCategory.fromJson(Map<String, dynamic> json) => _$ActiveCategoryFromJson(json);

@override final  String categoryId;
@override final  String categoryName;
@override final  int itemsSold;
@override final  double revenue;

/// Create a copy of ActiveCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveCategoryCopyWith<_ActiveCategory> get copyWith => __$ActiveCategoryCopyWithImpl<_ActiveCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,itemsSold,revenue);

@override
String toString() {
  return 'ActiveCategory(categoryId: $categoryId, categoryName: $categoryName, itemsSold: $itemsSold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$ActiveCategoryCopyWith<$Res> implements $ActiveCategoryCopyWith<$Res> {
  factory _$ActiveCategoryCopyWith(_ActiveCategory value, $Res Function(_ActiveCategory) _then) = __$ActiveCategoryCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String categoryName, int itemsSold, double revenue
});




}
/// @nodoc
class __$ActiveCategoryCopyWithImpl<$Res>
    implements _$ActiveCategoryCopyWith<$Res> {
  __$ActiveCategoryCopyWithImpl(this._self, this._then);

  final _ActiveCategory _self;
  final $Res Function(_ActiveCategory) _then;

/// Create a copy of ActiveCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? itemsSold = null,Object? revenue = null,}) {
  return _then(_ActiveCategory(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$RecentTransaction {

 String get id; String get staffName; String? get customerName; bool get isCredit; double get totalAmount; DateTime get createdAt; int get itemsCount;
/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentTransactionCopyWith<RecentTransaction> get copyWith => _$RecentTransactionCopyWithImpl<RecentTransaction>(this as RecentTransaction, _$identity);

  /// Serializes this RecentTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.staffName, staffName) || other.staffName == staffName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,staffName,customerName,isCredit,totalAmount,createdAt,itemsCount);

@override
String toString() {
  return 'RecentTransaction(id: $id, staffName: $staffName, customerName: $customerName, isCredit: $isCredit, totalAmount: $totalAmount, createdAt: $createdAt, itemsCount: $itemsCount)';
}


}

/// @nodoc
abstract mixin class $RecentTransactionCopyWith<$Res>  {
  factory $RecentTransactionCopyWith(RecentTransaction value, $Res Function(RecentTransaction) _then) = _$RecentTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String staffName, String? customerName, bool isCredit, double totalAmount, DateTime createdAt, int itemsCount
});




}
/// @nodoc
class _$RecentTransactionCopyWithImpl<$Res>
    implements $RecentTransactionCopyWith<$Res> {
  _$RecentTransactionCopyWithImpl(this._self, this._then);

  final RecentTransaction _self;
  final $Res Function(RecentTransaction) _then;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? staffName = null,Object? customerName = freezed,Object? isCredit = null,Object? totalAmount = null,Object? createdAt = null,Object? itemsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffName: null == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentTransaction].
extension RecentTransactionPatterns on RecentTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RecentTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  int itemsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that.id,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.itemsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  int itemsCount)  $default,) {final _that = this;
switch (_that) {
case _RecentTransaction():
return $default(_that.id,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.itemsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String staffName,  String? customerName,  bool isCredit,  double totalAmount,  DateTime createdAt,  int itemsCount)?  $default,) {final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that.id,_that.staffName,_that.customerName,_that.isCredit,_that.totalAmount,_that.createdAt,_that.itemsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentTransaction implements RecentTransaction {
  const _RecentTransaction({required this.id, required this.staffName, this.customerName, required this.isCredit, required this.totalAmount, required this.createdAt, required this.itemsCount});
  factory _RecentTransaction.fromJson(Map<String, dynamic> json) => _$RecentTransactionFromJson(json);

@override final  String id;
@override final  String staffName;
@override final  String? customerName;
@override final  bool isCredit;
@override final  double totalAmount;
@override final  DateTime createdAt;
@override final  int itemsCount;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentTransactionCopyWith<_RecentTransaction> get copyWith => __$RecentTransactionCopyWithImpl<_RecentTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.staffName, staffName) || other.staffName == staffName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,staffName,customerName,isCredit,totalAmount,createdAt,itemsCount);

@override
String toString() {
  return 'RecentTransaction(id: $id, staffName: $staffName, customerName: $customerName, isCredit: $isCredit, totalAmount: $totalAmount, createdAt: $createdAt, itemsCount: $itemsCount)';
}


}

/// @nodoc
abstract mixin class _$RecentTransactionCopyWith<$Res> implements $RecentTransactionCopyWith<$Res> {
  factory _$RecentTransactionCopyWith(_RecentTransaction value, $Res Function(_RecentTransaction) _then) = __$RecentTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String staffName, String? customerName, bool isCredit, double totalAmount, DateTime createdAt, int itemsCount
});




}
/// @nodoc
class __$RecentTransactionCopyWithImpl<$Res>
    implements _$RecentTransactionCopyWith<$Res> {
  __$RecentTransactionCopyWithImpl(this._self, this._then);

  final _RecentTransaction _self;
  final $Res Function(_RecentTransaction) _then;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? staffName = null,Object? customerName = freezed,Object? isCredit = null,Object? totalAmount = null,Object? createdAt = null,Object? itemsCount = null,}) {
  return _then(_RecentTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffName: null == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeeklyStat {

 DateTime get startDate; DateTime get endDate; double get amount;
/// Create a copy of WeeklyStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyStatCopyWith<WeeklyStat> get copyWith => _$WeeklyStatCopyWithImpl<WeeklyStat>(this as WeeklyStat, _$identity);

  /// Serializes this WeeklyStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyStat&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,amount);

@override
String toString() {
  return 'WeeklyStat(startDate: $startDate, endDate: $endDate, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $WeeklyStatCopyWith<$Res>  {
  factory $WeeklyStatCopyWith(WeeklyStat value, $Res Function(WeeklyStat) _then) = _$WeeklyStatCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate, double amount
});




}
/// @nodoc
class _$WeeklyStatCopyWithImpl<$Res>
    implements $WeeklyStatCopyWith<$Res> {
  _$WeeklyStatCopyWithImpl(this._self, this._then);

  final WeeklyStat _self;
  final $Res Function(WeeklyStat) _then;

/// Create a copy of WeeklyStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? amount = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyStat].
extension WeeklyStatPatterns on WeeklyStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyStat value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyStat value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyStat() when $default != null:
return $default(_that.startDate,_that.endDate,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  double amount)  $default,) {final _that = this;
switch (_that) {
case _WeeklyStat():
return $default(_that.startDate,_that.endDate,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startDate,  DateTime endDate,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyStat() when $default != null:
return $default(_that.startDate,_that.endDate,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyStat implements WeeklyStat {
  const _WeeklyStat({required this.startDate, required this.endDate, required this.amount});
  factory _WeeklyStat.fromJson(Map<String, dynamic> json) => _$WeeklyStatFromJson(json);

@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  double amount;

/// Create a copy of WeeklyStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyStatCopyWith<_WeeklyStat> get copyWith => __$WeeklyStatCopyWithImpl<_WeeklyStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyStat&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,amount);

@override
String toString() {
  return 'WeeklyStat(startDate: $startDate, endDate: $endDate, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$WeeklyStatCopyWith<$Res> implements $WeeklyStatCopyWith<$Res> {
  factory _$WeeklyStatCopyWith(_WeeklyStat value, $Res Function(_WeeklyStat) _then) = __$WeeklyStatCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, DateTime endDate, double amount
});




}
/// @nodoc
class __$WeeklyStatCopyWithImpl<$Res>
    implements _$WeeklyStatCopyWith<$Res> {
  __$WeeklyStatCopyWithImpl(this._self, this._then);

  final _WeeklyStat _self;
  final $Res Function(_WeeklyStat) _then;

/// Create a copy of WeeklyStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? amount = null,}) {
  return _then(_WeeklyStat(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ProductAlert {

 String get productId; String get productName; int get currentQuantity; int get threshold; String get message;
/// Create a copy of ProductAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAlertCopyWith<ProductAlert> get copyWith => _$ProductAlertCopyWithImpl<ProductAlert>(this as ProductAlert, _$identity);

  /// Serializes this ProductAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAlert&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,currentQuantity,threshold,message);

@override
String toString() {
  return 'ProductAlert(productId: $productId, productName: $productName, currentQuantity: $currentQuantity, threshold: $threshold, message: $message)';
}


}

/// @nodoc
abstract mixin class $ProductAlertCopyWith<$Res>  {
  factory $ProductAlertCopyWith(ProductAlert value, $Res Function(ProductAlert) _then) = _$ProductAlertCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, int currentQuantity, int threshold, String message
});




}
/// @nodoc
class _$ProductAlertCopyWithImpl<$Res>
    implements $ProductAlertCopyWith<$Res> {
  _$ProductAlertCopyWithImpl(this._self, this._then);

  final ProductAlert _self;
  final $Res Function(ProductAlert) _then;

/// Create a copy of ProductAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? currentQuantity = null,Object? threshold = null,Object? message = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAlert].
extension ProductAlertPatterns on ProductAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAlert value)  $default,){
final _that = this;
switch (_that) {
case _ProductAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAlert value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  int currentQuantity,  int threshold,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductAlert() when $default != null:
return $default(_that.productId,_that.productName,_that.currentQuantity,_that.threshold,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  int currentQuantity,  int threshold,  String message)  $default,) {final _that = this;
switch (_that) {
case _ProductAlert():
return $default(_that.productId,_that.productName,_that.currentQuantity,_that.threshold,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  int currentQuantity,  int threshold,  String message)?  $default,) {final _that = this;
switch (_that) {
case _ProductAlert() when $default != null:
return $default(_that.productId,_that.productName,_that.currentQuantity,_that.threshold,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductAlert implements ProductAlert {
  const _ProductAlert({required this.productId, required this.productName, required this.currentQuantity, required this.threshold, required this.message});
  factory _ProductAlert.fromJson(Map<String, dynamic> json) => _$ProductAlertFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  int currentQuantity;
@override final  int threshold;
@override final  String message;

/// Create a copy of ProductAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAlertCopyWith<_ProductAlert> get copyWith => __$ProductAlertCopyWithImpl<_ProductAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAlert&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,currentQuantity,threshold,message);

@override
String toString() {
  return 'ProductAlert(productId: $productId, productName: $productName, currentQuantity: $currentQuantity, threshold: $threshold, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ProductAlertCopyWith<$Res> implements $ProductAlertCopyWith<$Res> {
  factory _$ProductAlertCopyWith(_ProductAlert value, $Res Function(_ProductAlert) _then) = __$ProductAlertCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, int currentQuantity, int threshold, String message
});




}
/// @nodoc
class __$ProductAlertCopyWithImpl<$Res>
    implements _$ProductAlertCopyWith<$Res> {
  __$ProductAlertCopyWithImpl(this._self, this._then);

  final _ProductAlert _self;
  final $Res Function(_ProductAlert) _then;

/// Create a copy of ProductAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? currentQuantity = null,Object? threshold = null,Object? message = null,}) {
  return _then(_ProductAlert(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
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
