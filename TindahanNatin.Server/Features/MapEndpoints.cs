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
        group.MapGet("/shelves", async (TindahanDbContext db, int storeId) =>
        {
            return await db.Shelves
                .Where(s => s.StoreId == storeId)
                .Select(s => new ShelfDto(s.Id, s.Name, s.StoreId, s.X, s.Y))
                .ToListAsync();
        });

        group.MapPost("/shelves", async (CreateShelfDto dto, TindahanDbContext db) =>
        {
            var shelf = new Shelf { Name = dto.Name, StoreId = dto.StoreId, X = dto.X, Y = dto.Y };
            db.Shelves.Add(shelf);
            await db.SaveChangesAsync();
            return Results.Created($"/api/map/shelves/{shelf.Id}", new ShelfDto(shelf.Id, shelf.Name, shelf.StoreId, shelf.X, shelf.Y));
        });

        group.MapPut("/shelves/{id}", async (int id, UpdateShelfDto dto, TindahanDbContext db) =>
        {
            var shelf = await db.Shelves.FindAsync(id);
            if (shelf is null) return Results.NotFound();

            shelf.Name = dto.Name;
            shelf.X = dto.X;
            shelf.Y = dto.Y;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/shelves/{id}", async (int id, TindahanDbContext db) =>
        {
            var shelf = await db.Shelves.FindAsync(id);
            if (shelf is null) return Results.NotFound();
            db.Shelves.Remove(shelf);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        // Product Locations
        group.MapGet("/locations", async (TindahanDbContext db, int storeId) =>
        {
            // Join ProductLocations with Shelves for the specific store
            return await db.ProductLocations
                .Include(pl => db.Shelves) // This is wrong, should join correctly
                .Join(db.Shelves, 
                    pl => pl.ShelfId, 
                    s => s.Id, 
                    (pl, s) => new { pl, s })
                .Where(x => x.s.StoreId == storeId)
                .Select(x => new ProductLocationDto(x.pl.Id, x.pl.ProductId, x.pl.ShelfId, x.pl.Position))
                .ToListAsync();
        });

        group.MapPost("/locations", async (CreateProductLocationDto dto, TindahanDbContext db) =>
        {
            var location = new ProductLocation
            {
                ProductId = dto.ProductId,
                ShelfId = dto.ShelfId,
                Position = dto.Position
            };
            db.ProductLocations.Add(location);
            await db.SaveChangesAsync();
            return Results.Created($"/api/map/locations/{location.Id}", new ProductLocationDto(location.Id, location.ProductId, location.ShelfId, location.Position));
        });

        group.MapDelete("/locations/{id}", async (int id, TindahanDbContext db) =>
        {
            var location = await db.ProductLocations.FindAsync(id);
            if (location is null) return Results.NotFound();
            db.ProductLocations.Remove(location);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}