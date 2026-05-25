using System;

namespace TindahanNatin.Server.Models;

public class StoreMembership
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid StoreId { get; set; }
    public string UserId { get; set; } = string.Empty; // Identity provider ID (sub)
    public string Role { get; set; } = string.Empty; // Owner, Manager, Crew
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
