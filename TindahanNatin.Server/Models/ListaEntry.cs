using System;
using System.Collections.Generic;

namespace TindahanNatin.Server.Models;

public class ListaEntry
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid StoreId { get; set; }
    public string StaffName { get; set; } = string.Empty;
    public string? CustomerName { get; set; }
    public bool IsCredit { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    public List<ListaItem> Items { get; set; } = new();
}
