using System;
using System.Collections.Generic;

namespace TindahanNatin.Server.Dtos;

public record StoreStatsDto(
    decimal TotalSales,
    decimal TotalCredit,
    int TotalTransactions,
    List<DailyStatDto> DailyPerformance,
    List<TopProductDto> TopProducts
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
