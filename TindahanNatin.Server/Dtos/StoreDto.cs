using System;

namespace TindahanNatin.Server.Dtos;

public record StoreDto(Guid Id, string Name, string Slug, string OwnerId);

public record UpdateStoreDto(string Name);
