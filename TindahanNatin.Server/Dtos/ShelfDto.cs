namespace TindahanNatin.Server.Dtos;

public record ShelfDto(int Id, string Name, int StoreId, double X, double Y);
public record CreateShelfDto(string Name, int StoreId, double X = 0, double Y = 0);
public record UpdateShelfDto(string Name, double X, double Y);

public record ProductLocationDto(int Id, int ProductId, int ShelfId, string Position);
public record CreateProductLocationDto(int ProductId, int ShelfId, string Position);