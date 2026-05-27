// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreStats _$StoreStatsFromJson(Map<String, dynamic> json) => _StoreStats(
  totalSales: (json['totalSales'] as num).toDouble(),
  totalCredit: (json['totalCredit'] as num).toDouble(),
  totalTransactions: (json['totalTransactions'] as num).toInt(),
  dailyPerformance: (json['dailyPerformance'] as List<dynamic>)
      .map((e) => DailyStat.fromJson(e as Map<String, dynamic>))
      .toList(),
  topProducts: (json['topProducts'] as List<dynamic>)
      .map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StoreStatsToJson(_StoreStats instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalCredit': instance.totalCredit,
      'totalTransactions': instance.totalTransactions,
      'dailyPerformance': instance.dailyPerformance,
      'topProducts': instance.topProducts,
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
