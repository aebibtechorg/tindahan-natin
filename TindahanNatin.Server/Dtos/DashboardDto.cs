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
    List<ProductAlertDto> Alerts
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
