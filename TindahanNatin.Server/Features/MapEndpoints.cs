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
        var group = routes.MapGroup("/api/map").WithTags("Store Map").RequireAuthorization();

        // Shelves
        group.MapGet("/shelves", async (HttpContext context, TindahanDbContext db, Guid storeId, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var shelvesQuery = db.OwnedShelves(userId, includeDeleted).Where(s => s.StoreId == storeId);

            if (updatedSince.HasValue)
            {
                shelvesQuery = shelvesQuery.Where(s => s.UpdatedAt >= updatedSince.Value || s.CreatedAt >= updatedSince.Value);
            }

            return Results.Ok(await shelvesQuery
                .Select(s => new ShelfDto(s.Id, s.Name, s.StoreId, s.X, s.Y, s.Rotation, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.DeletedAt))
                .ToListAsync());
        });

        group.MapPost("/shelves", async (CreateShelfDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, dto.StoreId)) return Results.Forbid();

            var shelf = new Shelf { Id = dto.Id ?? Guid.NewGuid(), Name = dto.Name, StoreId = dto.StoreId, X = dto.X, Y = dto.Y, Rotation = dto.Rotation, CreatedAt = DateTimeOffset.UtcNow, UpdatedAt = DateTimeOffset.UtcNow };
            db.Shelves.Add(shelf);
            await db.SaveChangesAsync();
            return Results.Created($"/api/map/shelves/{shelf.Id}", new ShelfDto(shelf.Id, shelf.Name, shelf.StoreId, shelf.X, shelf.Y, shelf.Rotation, shelf.CreatedAt, shelf.UpdatedAt, shelf.IsDeleted, shelf.DeletedAt));
        });

        group.MapPut("/shelves/{id}", async (Guid id, UpdateShelfDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var shelf = await db.OwnedShelves(userId).FirstOrDefaultAsync(s => s.Id == id);
            if (shelf is null) return Results.NotFound();

            shelf.Name = dto.Name;
            shelf.X = dto.X;
            shelf.Y = dto.Y;
            shelf.Rotation = dto.Rotation;
            shelf.UpdatedAt = DateTimeOffset.UtcNow;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/shelves/{id}", async (Guid id, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var shelf = await db.OwnedShelves(userId).FirstOrDefaultAsync(s => s.Id == id);
            if (shelf is null) return Results.NotFound();

            shelf.IsDeleted = true;
            shelf.DeletedAt = DateTimeOffset.UtcNow;
            shelf.UpdatedAt = shelf.DeletedAt.Value;

            var locations = await db.OwnedProductLocations(userId).Where(pl => pl.ShelfId == id).ToListAsync();
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
        group.MapGet("/locations", async (HttpContext context, TindahanDbContext db, Guid storeId, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var query = db.OwnedProductLocations(userId, includeDeleted)
                .Join(db.OwnedShelves(userId, includeDeleted),
                    pl => pl.ShelfId,
                    s => s.Id,
                    (pl, s) => new { pl, s })
                .Where(x => x.s.StoreId == storeId)
                .AsQueryable();

            if (updatedSince.HasValue)
            {
                query = query.Where(x => x.pl.UpdatedAt >= updatedSince.Value || x.pl.CreatedAt >= updatedSince.Value);
            }

            return Results.Ok(await query
                .Select(x => new ProductLocationDto(x.pl.Id, x.pl.ProductId, x.pl.ShelfId, x.pl.Position, x.pl.CreatedAt, x.pl.UpdatedAt, x.pl.IsDeleted, x.pl.DeletedAt))
                .ToListAsync());
        });

        group.MapPost("/locations", async (CreateProductLocationDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var productStoreId = await db.OwnedProducts(userId).Where(p => p.Id == dto.ProductId).Select(p => (Guid?)p.StoreId).FirstOrDefaultAsync();
            if (!productStoreId.HasValue) return Results.Forbid();

            var shelfStoreId = await db.OwnedShelves(userId).Where(s => s.Id == dto.ShelfId).Select(s => (Guid?)s.StoreId).FirstOrDefaultAsync();
            if (!shelfStoreId.HasValue) return Results.Forbid();
            if (productStoreId != shelfStoreId) return Results.BadRequest("Product and shelf must belong to the same store.");

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

        group.MapDelete("/locations/{id}", async (Guid id, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var location = await db.OwnedProductLocations(userId).FirstOrDefaultAsync(pl => pl.Id == id);
            if (location is null) return Results.NotFound();

            location.IsDeleted = true;
            location.DeletedAt = DateTimeOffset.UtcNow;
            location.UpdatedAt = location.DeletedAt.Value;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}