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

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>().Property(u => u.Id).HasColumnType("uuid");

        modelBuilder.Entity<Store>().Property(s => s.Id).HasColumnType("uuid");

        modelBuilder.Entity<Category>().Property(c => c.Id).HasColumnType("uuid");
        modelBuilder.Entity<Category>().Property(c => c.StoreId).HasColumnType("uuid");

        modelBuilder.Entity<Product>().Property(p => p.Id).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.CategoryId).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.StoreId).HasColumnType("uuid");

        modelBuilder.Entity<Shelf>().Property(s => s.Id).HasColumnType("uuid");
        modelBuilder.Entity<Shelf>().Property(s => s.StoreId).HasColumnType("uuid");

        modelBuilder.Entity<ProductLocation>().Property(pl => pl.Id).HasColumnType("uuid");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.ProductId).HasColumnType("uuid");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.ShelfId).HasColumnType("uuid");
    }
}