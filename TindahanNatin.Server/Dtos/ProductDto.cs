using System;

namespace TindahanNatin.Server.Dtos;

public record ProductDto(
    Guid Id,
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    Guid? ShelfId,
    string? Description,
    string? ImageUrl,
    string? Barcode,
    Guid StoreId,
    DateTimeOffset CreatedAt,
    DateTimeOffset UpdatedAt,
    bool IsDeleted,
    DateTimeOffset? DeletedAt
);

public record CreateProductDto(
    Guid? Id,
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    Guid? ShelfId,
    string? Description,
    string? Barcode,
    Guid StoreId
);

public record UpdateProductDto(
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    Guid? ShelfId,
    string? Description,
    string? Barcode
);