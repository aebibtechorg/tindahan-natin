import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_stats.freezed.dart';
part 'store_stats.g.dart';

@freezed
abstract class StoreStats with _$StoreStats {
  const factory StoreStats({
    required double totalSales,
    required double totalCredit,
    required int totalTransactions,
    required List<DailyStat> dailyPerformance,
    required List<TopProduct> topProducts,
  }) = _StoreStats;

  factory StoreStats.fromJson(Map<String, dynamic> json) => _$StoreStatsFromJson(json);
}

@freezed
abstract class DailyStat with _$DailyStat {
  const factory DailyStat({
    required DateTime date,
    required double amount,
  }) = _DailyStat;

  factory DailyStat.fromJson(Map<String, dynamic> json) => _$DailyStatFromJson(json);
}

@freezed
abstract class TopProduct with _$TopProduct {
  const factory TopProduct({
    required String productId,
    required String productName,
    required int quantitySold,
    required double totalRevenue,
  }) = _TopProduct;

  factory TopProduct.fromJson(Map<String, dynamic> json) => _$TopProductFromJson(json);
}
