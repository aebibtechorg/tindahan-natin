using System;

namespace TindahanNatin.Server.Dtos;

public record CategoryDto(
    Guid Id,
    string Name,
    Guid StoreId
);

public record CreateCategoryDto(
    string Name,
    Guid StoreId
);

public record UpdateCategoryDto(
    string Name
);
