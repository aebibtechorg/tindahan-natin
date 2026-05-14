using System;

namespace TindahanNatin.Server.Dtos;

public record CategoryDto(
    Guid Id,
    string Name,
    Guid StoreId,
    DateTimeOffset CreatedAt,
    DateTimeOffset UpdatedAt,
    bool IsDeleted,
    DateTimeOffset? DeletedAt
);

public record CreateCategoryDto(
    Guid? Id,
    string Name,
    Guid StoreId
);

public record UpdateCategoryDto(
    string Name
);
