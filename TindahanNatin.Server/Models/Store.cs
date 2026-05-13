namespace TindahanNatin.Server.Models;

public class Store
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty; // for the shareable link
    public string OwnerId { get; set; } = string.Empty;
}