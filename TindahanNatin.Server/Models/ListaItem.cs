using System;

namespace TindahanNatin.Server.Models;

public class ListaItem
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid ListaEntryId { get; set; }
    public Guid ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public decimal Price { get; set; }
}
