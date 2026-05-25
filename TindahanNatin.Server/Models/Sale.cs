using System;

namespace TindahanNatin.Server.Models;

public class Sale
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid StoreId { get; set; }
    public Guid? ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public decimal PriceAtSale { get; set; }
    public int Quantity { get; set; }
    public decimal TotalPrice { get; set; }
    public bool IsCredit { get; set; }
    public string? CustomerName { get; set; }
    public string SoldById { get; set; } = string.Empty;
    public string? SoldByName { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
