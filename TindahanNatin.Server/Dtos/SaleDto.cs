using System;

namespace TindahanNatin.Server.Dtos;

public record SaleDto(
    Guid Id,
    Guid StoreId,
    Guid? ProductId,
    string ProductName,
    decimal PriceAtSale,
    int Quantity,
    decimal TotalPrice,
    bool IsCredit,
    string? CustomerName,
    string SoldById,
    string? SoldByName,
    DateTimeOffset CreatedAt
);

public record CreateSaleDto(
    Guid? Id,
    Guid StoreId,
    Guid? ProductId,
    string ProductName,
    decimal PriceAtSale,
    int Quantity,
    decimal TotalPrice,
    bool IsCredit,
    string? CustomerName
);
