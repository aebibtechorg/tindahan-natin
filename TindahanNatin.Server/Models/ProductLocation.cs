namespace TindahanNatin.Server.Models;

public class ProductLocation
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public int ShelfId { get; set; }
    public string Position { get; set; } = string.Empty; // e.g., "Left Side"
}