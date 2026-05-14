using System;

namespace TindahanNatin.Server.Dtos;

public record ShelfDto(Guid Id, string Name, Guid StoreId, double X, double Y, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt, bool IsDeleted, DateTimeOffset? DeletedAt);
public record CreateShelfDto(Guid? Id, string Name, Guid StoreId, double X = 0, double Y = 0);
public record UpdateShelfDto(string Name, double X, double Y);

public record ProductLocationDto(Guid Id, Guid ProductId, Guid ShelfId, string Position, DateTimeOffset CreatedAt, DateTimeOffset UpdatedAt, bool IsDeleted, DateTimeOffset? DeletedAt);
public record CreateProductLocationDto(Guid? Id, Guid ProductId, Guid ShelfId, string Position);