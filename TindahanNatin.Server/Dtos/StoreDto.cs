using System;

namespace TindahanNatin.Server.Dtos;

public record StoreDto(Guid Id, string Name, string Slug, string OwnerId, string? InviteCode, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt);

public record JoinStoreDto(string InviteCode);

public record StoreMembershipDto(
    Guid Id,
    Guid StoreId,
    string StoreName,
    string StoreSlug,
    string Role,
    string? InviteCode,
    DateTimeOffset CreatedAt
);

public record UpdateStoreDto(string Name);
