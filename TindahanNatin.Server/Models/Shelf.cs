using System;

namespace TindahanNatin.Server.Models;

public class Shelf
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public Guid StoreId { get; set; }
    public double X { get; set; } = 0;
    public double Y { get; set; } = 0;
}