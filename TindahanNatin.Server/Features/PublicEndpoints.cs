using System;
using Microsoft.EntityFrameworkCore;
using Npgsql.EntityFrameworkCore.PostgreSQL;
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

            // If no query, use LINQ + left join for shelf info.
            if (string.IsNullOrEmpty(q))
            {
                var productsAll = await (from p in db.Products.Where(p => p.StoreId == store.Id)
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
                                          ShelfId = (Guid?)subpl.ShelfId
                                      }).ToListAsync();

                return Results.Ok(productsAll);
            }

            var pattern = $"%{q.Trim()}%";

            var matchedProducts = await db.Products
                .Where(p => p.StoreId == store.Id && ((p.SearchVector != null && p.SearchVector.Matches(EF.Functions.WebSearchToTsQuery("simple", q))) || EF.Functions.ILike(p.Name, pattern) || EF.Functions.ILike(p.Description ?? string.Empty, pattern) || EF.Functions.ILike(p.Barcode ?? string.Empty, pattern)))
                .ToListAsync();

            // Load locations for matched products to attach shelf info
            var ids = matchedProducts.Select(p => p.Id).ToList();
            var locations = await db.ProductLocations.Where(pl => ids.Contains(pl.ProductId)).ToListAsync();

            var products = matchedProducts.Select(p => new {
                p.Id,
                p.Name,
                p.Price,
                p.Quantity,
                p.CategoryId,
                p.Description,
                p.ImageUrl,
                p.Barcode,
                p.StoreId,
                ShelfId = (Guid?)locations.FirstOrDefault(l => l.ProductId == p.Id)?.ShelfId
            }).ToList();

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