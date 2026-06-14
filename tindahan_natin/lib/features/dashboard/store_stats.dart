import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_stats.freezed.dart';
part 'store_stats.g.dart';

@freezed
abstract class StoreStats with _$StoreStats {
  const factory StoreStats({
    required double totalSales,
    required double totalCredit,
    required int totalTransactions,
    required double performanceChange,
    required List<DailyStat> dailyPerformance,
    required List<TopProduct> topProducts,
    @Default([]) List<ProductAlert> alerts,
    required double totalInventoryValue,
    required List<ActiveCategory> mostActiveCategories,
    required List<RecentTransaction> recentTransactions,
    required List<WeeklyStat> weeklyPerformance,
  }) = _StoreStats;

  factory StoreStats.fromJson(Map<String, dynamic> json) => _$StoreStatsFromJson(json);
}

@freezed
abstract class ActiveCategory with _$ActiveCategory {
  const factory ActiveCategory({
    required String categoryId,
    required String categoryName,
    required int itemsSold,
    required double revenue,
  }) = _ActiveCategory;

  factory ActiveCategory.fromJson(Map<String, dynamic> json) => _$ActiveCategoryFromJson(json);
}

@freezed
abstract class RecentTransaction with _$RecentTransaction {
  const factory RecentTransaction({
    required String id,
    required String staffName,
    String? customerName,
    required bool isCredit,
    required double totalAmount,
    required DateTime createdAt,
    required int itemsCount,
  }) = _RecentTransaction;

  factory RecentTransaction.fromJson(Map<String, dynamic> json) => _$RecentTransactionFromJson(json);
}

@freezed
abstract class WeeklyStat with _$WeeklyStat {
  const factory WeeklyStat({
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
  }) = _WeeklyStat;

  factory WeeklyStat.fromJson(Map<String, dynamic> json) => _$WeeklyStatFromJson(json);
}

@freezed
abstract class ProductAlert with _$ProductAlert {
  const factory ProductAlert({
    required String productId,
    required String productName,
    required int currentQuantity,
    required int threshold,
    required String message,
  }) = _ProductAlert;

  factory ProductAlert.fromJson(Map<String, dynamic> json) => _$ProductAlertFromJson(json);
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
