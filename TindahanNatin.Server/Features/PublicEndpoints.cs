using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class PublicEndpoints
{
    public static void MapPublicEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/public").WithTags("Public");

        // Search products in a specific store
        group.MapGet("/stores/{slug}/products", async (string slug, string? q, TindahanDbContext db) =>
        {
            var store = await db.Stores.FirstOrDefaultAsync(s => s.Slug == slug);
            if (store == null) return Results.NotFound("Store not found");

            var query = db.Products.Where(p => p.StoreId == store.Id);

            if (!string.IsNullOrEmpty(q))
            {
                query = query.Where(p => EF.Functions.ILike(p.Name, $"%{q}%"));
            }

            var products = await (from p in query
                                  join pl in db.ProductLocations on p.Id equals pl.ProductId into pls
                                  from subpl in pls.DefaultIfEmpty()
                                  select new {
                                      p.Id,
                                      p.Name,
                                      p.Price,
                                      p.Quantity,
                                      p.CategoryId,
                                      p.Description,
                                      p.ImageUrl,
                                      p.Barcode,
                                      p.StoreId,
                                      ShelfId = (int?)subpl.ShelfId
                                  }).ToListAsync();

            return Results.Ok(products);
        }).AllowAnonymous();

        // Get store info and map
        group.MapGet("/stores/{slug}", async (string slug, TindahanDbContext db) =>
        {
            var store = await db.Stores.FirstOrDefaultAsync(s => s.Slug == slug);
            if (store == null) return Results.NotFound("Store not found");

            var shelves = await db.Shelves
                .Where(s => s.StoreId == store.Id)
                .Select(s => new ShelfDto(s.Id, s.Name, s.StoreId, s.X, s.Y))
                .ToListAsync();

            return Results.Ok(new { Store = store, Shelves = shelves });
        }).AllowAnonymous();
    }
}