// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreStats _$StoreStatsFromJson(Map<String, dynamic> json) => _StoreStats(
  totalSales: (json['totalSales'] as num).toDouble(),
  totalCredit: (json['totalCredit'] as num).toDouble(),
  totalTransactions: (json['totalTransactions'] as num).toInt(),
  performanceChange: (json['performanceChange'] as num).toDouble(),
  dailyPerformance: (json['dailyPerformance'] as List<dynamic>)
      .map((e) => DailyStat.fromJson(e as Map<String, dynamic>))
      .toList(),
  topProducts: (json['topProducts'] as List<dynamic>)
      .map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  alerts:
      (json['alerts'] as List<dynamic>?)
          ?.map((e) => ProductAlert.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalInventoryValue: (json['totalInventoryValue'] as num).toDouble(),
  mostActiveCategories: (json['mostActiveCategories'] as List<dynamic>)
      .map((e) => ActiveCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentTransactions: (json['recentTransactions'] as List<dynamic>)
      .map((e) => RecentTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  weeklyPerformance: (json['weeklyPerformance'] as List<dynamic>)
      .map((e) => WeeklyStat.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StoreStatsToJson(_StoreStats instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalCredit': instance.totalCredit,
      'totalTransactions': instance.totalTransactions,
      'performanceChange': instance.performanceChange,
      'dailyPerformance': instance.dailyPerformance,
      'topProducts': instance.topProducts,
      'alerts': instance.alerts,
      'totalInventoryValue': instance.totalInventoryValue,
      'mostActiveCategories': instance.mostActiveCategories,
      'recentTransactions': instance.recentTransactions,
      'weeklyPerformance': instance.weeklyPerformance,
    };

_ActiveCategory _$ActiveCategoryFromJson(Map<String, dynamic> json) =>
    _ActiveCategory(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      itemsSold: (json['itemsSold'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$ActiveCategoryToJson(_ActiveCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'itemsSold': instance.itemsSold,
      'revenue': instance.revenue,
    };

_RecentTransaction _$RecentTransactionFromJson(Map<String, dynamic> json) =>
    _RecentTransaction(
      id: json['id'] as String,
      staffName: json['staffName'] as String,
      customerName: json['customerName'] as String?,
      isCredit: json['isCredit'] as bool,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      itemsCount: (json['itemsCount'] as num).toInt(),
    );

Map<String, dynamic> _$RecentTransactionToJson(_RecentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'staffName': instance.staffName,
      'customerName': instance.customerName,
      'isCredit': instance.isCredit,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'itemsCount': instance.itemsCount,
    };

_WeeklyStat _$WeeklyStatFromJson(Map<String, dynamic> json) => _WeeklyStat(
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$WeeklyStatToJson(_WeeklyStat instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'amount': instance.amount,
    };

_ProductAlert _$ProductAlertFromJson(Map<String, dynamic> json) =>
    _ProductAlert(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      currentQuantity: (json['currentQuantity'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ProductAlertToJson(_ProductAlert instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'currentQuantity': instance.currentQuantity,
      'threshold': instance.threshold,
      'message': instance.message,
    };

_DailyStat _$DailyStatFromJson(Map<String, dynamic> json) => _DailyStat(
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$DailyStatToJson(_DailyStat instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
    };

_TopProduct _$TopProductFromJson(Map<String, dynamic> json) => _TopProduct(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  quantitySold: (json['quantitySold'] as num).toInt(),
  totalRevenue: (json['totalRevenue'] as num).toDouble(),
);

Map<String, dynamic> _$TopProductToJson(_TopProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantitySold': instance.quantitySold,
      'totalRevenue': instance.totalRevenue,
    };
