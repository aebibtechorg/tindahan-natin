using System;
using NpgsqlTypes;

namespace TindahanNatin.Server.Models;

public class Product
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public Guid CategoryId { get; set; }
    public Guid? ShelfId { get; set; }
    public string? Description { get; set; }
    public string? ImageUrl { get; set; }
    public string? Barcode { get; set; }
    public Guid StoreId { get; set; }

    // PostgreSQL full-text search vector (generated column)
    public NpgsqlTsVector? SearchVector { get; set; }
}