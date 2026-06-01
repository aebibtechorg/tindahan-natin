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
