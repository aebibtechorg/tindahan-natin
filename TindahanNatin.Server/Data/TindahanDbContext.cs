using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Data;

public class TindahanDbContext : DbContext
{
    public TindahanDbContext(DbContextOptions<TindahanDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Store> Stores => Set<Store>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Product> Products => Set<Product>();
    public DbSet<Shelf> Shelves => Set<Shelf>();
    public DbSet<ProductLocation> ProductLocations => Set<ProductLocation>();
}