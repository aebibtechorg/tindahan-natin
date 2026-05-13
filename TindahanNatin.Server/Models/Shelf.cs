namespace TindahanNatin.Server.Models;

public class Shelf
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int StoreId { get; set; }
    public double X { get; set; } = 0;
    public double Y { get; set; } = 0;
}