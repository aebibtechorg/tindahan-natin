using System;
using NpgsqlTypes;

namespace TindahanNatin.Server.Models;

public class Category
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public Guid StoreId { get; set; }

    // PostgreSQL full-text search vector (generated column)
    public NpgsqlTsVector? SearchVector { get; set; }
}