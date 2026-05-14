using System;
using NpgsqlTypes;

namespace TindahanNatin.Server.Models;

public class Category
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public Guid StoreId { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
    public bool IsDeleted { get; set; }
    public DateTimeOffset? DeletedAt { get; set; }

    // PostgreSQL full-text search vector (generated column)
    public NpgsqlTsVector? SearchVector { get; set; }
}