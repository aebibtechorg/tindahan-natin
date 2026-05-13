namespace TindahanNatin.Server.Dtos;

public record ProductDto(
    int Id,
    string Name,
    decimal Price,
    int Quantity,
    int CategoryId,
    string? Description,
    string? ImageUrl,
    string? Barcode,
    int StoreId
);

public record CreateProductDto(
    string Name,
    decimal Price,
    int Quantity,
    int CategoryId,
    string? Description,
    string? Barcode,
    int StoreId
);

public record UpdateProductDto(
    string Name,
    decimal Price,
    int Quantity,
    int CategoryId,
    string? Description,
    string? Barcode
);