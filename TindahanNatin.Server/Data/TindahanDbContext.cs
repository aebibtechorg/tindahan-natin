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
        modelBuilder.Entity<Store>().Property(s => s.CreatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Store>().Property(s => s.UpdatedAt).HasColumnType("timestamp with time zone");

        modelBuilder.Entity<Category>().Property(c => c.Id).HasColumnType("uuid");
        modelBuilder.Entity<Category>().Property(c => c.StoreId).HasColumnType("uuid");
        modelBuilder.Entity<Category>().Property(c => c.CreatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Category>().Property(c => c.UpdatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Category>().Property(c => c.DeletedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Category>().HasQueryFilter(c => !c.IsDeleted);

        modelBuilder.Entity<Product>().Property(p => p.Id).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.CategoryId).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.ShelfId).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.StoreId).HasColumnType("uuid");
        modelBuilder.Entity<Product>().Property(p => p.CreatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Product>().Property(p => p.UpdatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Product>().Property(p => p.DeletedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Product>().HasQueryFilter(p => !p.IsDeleted);

        // Configure generated tsvector columns for PostgreSQL full-text search
        modelBuilder.Entity<Product>()
            .HasGeneratedTsVectorColumn(
                p => p.SearchVector,
                "simple",
                p => new { p.Name, p.Description, p.Barcode })
            .HasIndex(p => p.SearchVector)
            .HasMethod("GIN");

        modelBuilder.Entity<Category>()
            .HasGeneratedTsVectorColumn(
                c => c.SearchVector,
                "simple",
                c => new { c.Name })
            .HasIndex(c => c.SearchVector)
            .HasMethod("GIN");

        modelBuilder.Entity<Shelf>().Property(s => s.Id).HasColumnType("uuid");
        modelBuilder.Entity<Shelf>().Property(s => s.StoreId).HasColumnType("uuid");
        modelBuilder.Entity<Shelf>().Property(s => s.CreatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Shelf>().Property(s => s.UpdatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Shelf>().Property(s => s.DeletedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<Shelf>().HasQueryFilter(s => !s.IsDeleted);

        modelBuilder.Entity<ProductLocation>().Property(pl => pl.Id).HasColumnType("uuid");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.ProductId).HasColumnType("uuid");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.ShelfId).HasColumnType("uuid");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.CreatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.UpdatedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<ProductLocation>().Property(pl => pl.DeletedAt).HasColumnType("timestamp with time zone");
        modelBuilder.Entity<ProductLocation>().HasQueryFilter(pl => !pl.IsDeleted);
    }
}