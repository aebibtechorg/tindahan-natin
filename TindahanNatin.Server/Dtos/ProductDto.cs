using System;

namespace TindahanNatin.Server.Dtos;

public record ProductDto(
    Guid Id,
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    string? Description,
    string? ImageUrl,
    string? Barcode,
    Guid StoreId
);

public record CreateProductDto(
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    string? Description,
    string? Barcode,
    Guid StoreId
);

public record UpdateProductDto(
    string Name,
    decimal Price,
    int Quantity,
    Guid CategoryId,
    string? Description,
    string? Barcode
);