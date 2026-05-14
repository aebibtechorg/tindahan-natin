using System;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class MapEndpoints
{
    public static void MapMapEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/map").WithTags("Store Map");

        // Shelves
        group.MapGet("/shelves", async (TindahanDbContext db, Guid storeId, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var shelvesQuery = (includeDeleted ? db.Shelves.IgnoreQueryFilters() : db.Shelves)
                .Where(s => s.StoreId == storeId);

            if (updatedSince.HasValue)
            {
                shelvesQuery = shelvesQuery.Where(s => s.UpdatedAt >= updatedSince.Value || s.CreatedAt >= updatedSince.Value);
            }

            return await shelvesQuery
                .Select(s => new ShelfDto(s.Id, s.Name, s.StoreId, s.X, s.Y, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.DeletedAt))
                .ToListAsync();
        });

        group.MapPost("/shelves", async (CreateShelfDto dto, TindahanDbContext db) =>
        {
            var shelf = new Shelf { Id = dto.Id ?? Guid.NewGuid(), Name = dto.Name, StoreId = dto.StoreId, X = dto.X, Y = dto.Y, CreatedAt = DateTimeOffset.UtcNow, UpdatedAt = DateTimeOffset.UtcNow };
            db.Shelves.Add(shelf);
            await db.SaveChangesAsync();
            return Results.Created($"/api/map/shelves/{shelf.Id}", new ShelfDto(shelf.Id, shelf.Name, shelf.StoreId, shelf.X, shelf.Y, shelf.CreatedAt, shelf.UpdatedAt, shelf.IsDeleted, shelf.DeletedAt));
        });

        group.MapPut("/shelves/{id}", async (Guid id, UpdateShelfDto dto, TindahanDbContext db) =>
        {
            var shelf = await db.Shelves.FindAsync(id);
            if (shelf is null) return Results.NotFound();

            shelf.Name = dto.Name;
            shelf.X = dto.X;
            shelf.Y = dto.Y;
            shelf.UpdatedAt = DateTimeOffset.UtcNow;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/shelves/{id}", async (Guid id, TindahanDbContext db) =>
        {
            var shelf = await db.Shelves.FindAsync(id);
            if (shelf is null) return Results.NotFound();

            shelf.IsDeleted = true;
            shelf.DeletedAt = DateTimeOffset.UtcNow;
            shelf.UpdatedAt = shelf.DeletedAt.Value;

            var locations = await db.ProductLocations.Where(pl => pl.ShelfId == id).ToListAsync();
            foreach (var location in locations)
            {
                location.IsDeleted = true;
                location.DeletedAt = shelf.DeletedAt;
                location.UpdatedAt = shelf.DeletedAt.Value;
            }

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        // Product Locations
        group.MapGet("/locations", async (TindahanDbContext db, Guid storeId, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var locationsQuery = includeDeleted ? db.ProductLocations.IgnoreQueryFilters() : db.ProductLocations;
            var shelvesQuery = includeDeleted ? db.Shelves.IgnoreQueryFilters() : db.Shelves;

            var query = locationsQuery
                .Join(shelvesQuery,
                    pl => pl.ShelfId, 
                    s => s.Id, 
                    (pl, s) => new { pl, s })
                .Where(x => x.s.StoreId == storeId)
                .AsQueryable();

            if (updatedSince.HasValue)
            {
                query = query.Where(x => x.pl.UpdatedAt >= updatedSince.Value || x.pl.CreatedAt >= updatedSince.Value);
            }

            return await query
                .Select(x => new ProductLocationDto(x.pl.Id, x.pl.ProductId, x.pl.ShelfId, x.pl.Position, x.pl.CreatedAt, x.pl.UpdatedAt, x.pl.IsDeleted, x.pl.DeletedAt))
                .ToListAsync();
        });

        group.MapPost("/locations", async (CreateProductLocationDto dto, TindahanDbContext db) =>
        {
            var location = new ProductLocation
            {
                Id = dto.Id ?? Guid.NewGuid(),
                ProductId = dto.ProductId,
                ShelfId = dto.ShelfId,
                Position = dto.Position,
                CreatedAt = DateTimeOffset.UtcNow,
                UpdatedAt = DateTimeOffset.UtcNow
            };
            db.ProductLocations.Add(location);
            await db.SaveChangesAsync();
            return Results.Created($"/api/map/locations/{location.Id}", new ProductLocationDto(location.Id, location.ProductId, location.ShelfId, location.Position, location.CreatedAt, location.UpdatedAt, location.IsDeleted, location.DeletedAt));
        });

        group.MapDelete("/locations/{id}", async (Guid id, TindahanDbContext db) =>
        {
            var location = await db.ProductLocations.FindAsync(id);
            if (location is null) return Results.NotFound();

            location.IsDeleted = true;
            location.DeletedAt = DateTimeOffset.UtcNow;
            location.UpdatedAt = location.DeletedAt.Value;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}