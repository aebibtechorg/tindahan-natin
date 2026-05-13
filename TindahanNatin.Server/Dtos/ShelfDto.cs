using System;

namespace TindahanNatin.Server.Dtos;

public record ShelfDto(Guid Id, string Name, Guid StoreId, double X, double Y);
public record CreateShelfDto(string Name, Guid StoreId, double X = 0, double Y = 0);
public record UpdateShelfDto(string Name, double X, double Y);

public record ProductLocationDto(Guid Id, Guid ProductId, Guid ShelfId, string Position);
public record CreateProductLocationDto(Guid ProductId, Guid ShelfId, string Position);