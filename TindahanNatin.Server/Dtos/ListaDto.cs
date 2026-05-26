using System;
using System.Collections.Generic;

namespace TindahanNatin.Server.Dtos;

public record ListaEntryDto(
    Guid Id,
    Guid StoreId,
    string StaffName,
    string? CustomerName,
    bool IsCredit,
    decimal TotalAmount,
    DateTimeOffset CreatedAt,
    List<ListaItemDto> Items
);

public record ListaItemDto(
    Guid Id,
    Guid ProductId,
    string ProductName,
    int Quantity,
    decimal Price
);

public record CreateListaEntryDto(
    Guid StoreId,
    string StaffName,
    string? CustomerName,
    bool IsCredit,
    List<CreateListaItemDto> Items
);

public record CreateListaItemDto(
    Guid ProductId,
    int Quantity
);
