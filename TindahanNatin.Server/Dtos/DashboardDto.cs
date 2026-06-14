using System;
using System.Collections.Generic;

namespace TindahanNatin.Server.Dtos;

public record StoreStatsDto(
    decimal TotalSales,
    decimal TotalCredit,
    int TotalTransactions,
    double PerformanceChange,
    List<DailyStatDto> DailyPerformance,
    List<TopProductDto> TopProducts,
    List<ProductAlertDto> Alerts,
    decimal TotalInventoryValue,
    List<ActiveCategoryDto> MostActiveCategories,
    List<RecentTransactionDto> RecentTransactions,
    List<WeeklyStatDto> WeeklyPerformance
);

public record ProductAlertDto(
    Guid ProductId,
    string ProductName,
    int CurrentQuantity,
    int Threshold,
    string Message
);

public record DailyStatDto(
    DateTime Date,
    decimal Amount
);

public record TopProductDto(
    Guid ProductId,
    string ProductName,
    int QuantitySold,
    decimal TotalRevenue
);

public record ActiveCategoryDto(
    Guid CategoryId,
    string CategoryName,
    int ItemsSold,
    decimal Revenue
);

public record RecentTransactionDto(
    Guid Id,
    string StaffName,
    string? CustomerName,
    bool IsCredit,
    decimal TotalAmount,
    DateTimeOffset CreatedAt,
    int ItemsCount
);

public record WeeklyStatDto(
    DateTime StartDate,
    DateTime EndDate,
    decimal Amount
);
