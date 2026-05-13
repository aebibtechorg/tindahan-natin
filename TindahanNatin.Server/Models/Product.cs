namespace TindahanNatin.Server.Models;

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public int CategoryId { get; set; }
    public string? Description { get; set; }
    public string? ImageUrl { get; set; }
    public string? Barcode { get; set; }
    public int StoreId { get; set; }
}