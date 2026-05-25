using System;

namespace TindahanNatin.Server.Dtos;

public record StoreDto(Guid Id, string Name, string Slug, string OwnerId, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt);

public record StoreMembershipDto(
    Guid Id,
    Guid StoreId,
    string StoreName,
    string StoreSlug,
    string Role,
    DateTimeOffset CreatedAt
);

public record UpdateStoreDto(string Name);
