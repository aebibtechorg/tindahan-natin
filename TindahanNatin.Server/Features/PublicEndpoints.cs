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
                // var productsAll = await (from p in db.Products.Where(p => p.StoreId == store.Id)
                //                       join pl in db.ProductLocations on p.Id equals pl.ProductId into pls
                //                       from subpl in pls.DefaultIfEmpty()
                //                       join s in db.Shelves on subpl.ShelfId equals s.Id into shelfJoin
                //                       from shelf in shelfJoin.DefaultIfEmpty()
                //                       select new ProductDto(
                //                           p.Id,
                //                           p.Name,
                //                           p.Price,
                //                           p.Quantity,
                //                           p.CategoryId,
                //                           (Guid?)subpl.ShelfId,
                //                           p.Description,
                //                           p.ImageUrl,
                //                           p.Barcode,
                //                           p.StoreId,
                //                           p.CreatedAt,
                //                           p.UpdatedAt,
                //                           p.IsDeleted,
                //                           p.DeletedAt,
                //                           shelf != null ? shelf.Name : null
                //                       )).ToListAsync();
                var productsAll = await (
                    from p in db.Products
                    where p.StoreId == store.Id && !p.IsDeleted
                    join s in db.Shelves on p.ShelfId equals s.Id into shelfJoin
                    from shelf in shelfJoin.DefaultIfEmpty()
                    select new ProductDto(
                        p.Id,
                        p.Name,
                        p.Price,
                        p.Quantity,
                        p.CategoryId,
                        p.ShelfId,
                        p.Description,
                        p.ImageUrl,
                        p.Barcode,
                        p.StoreId,
                        p.CreatedAt,
                        p.UpdatedAt,
                        p.IsDeleted,
                        p.DeletedAt,
                        shelf != null ? shelf.Name : null
                    )).ToListAsync();

                return Results.Ok(productsAll);
            }

            var pattern = $"%{q.Trim()}%";

            var matchedProducts = await (
                from p in db.Products
                where p.StoreId == store.Id
                    && !p.IsDeleted
                    && ((p.SearchVector != null && p.SearchVector.Matches(EF.Functions.WebSearchToTsQuery("simple", q)))
                        || EF.Functions.ILike(p.Name, pattern)
                        || EF.Functions.ILike(p.Description ?? string.Empty, pattern)
                        || EF.Functions.ILike(p.Barcode ?? string.Empty, pattern))
                join s in db.Shelves on p.ShelfId equals s.Id into shelfJoin
                from shelf in shelfJoin.DefaultIfEmpty()
                select new ProductDto(
                    p.Id,
                    p.Name,
                    p.Price,
                    p.Quantity,
                    p.CategoryId,
                    p.ShelfId,
                    p.Description,
                    p.ImageUrl,
                    p.Barcode,
                    p.StoreId,
                    p.CreatedAt,
                    p.UpdatedAt,
                    p.IsDeleted,
                    p.DeletedAt,
                    shelf != null ? shelf.Name : null
                )).ToListAsync();

            // Load locations for matched products to attach shelf info
            // var ids = matchedProducts.Select(p => p.Id).ToList();
            // var locations = await db.ProductLocations.Where(pl => ids.Contains(pl.ProductId)).ToListAsync();
            // var shelfIds = locations.Select(l => l.ShelfId).Distinct().ToList();
            // var shelfNames = await db.Shelves
            //     .Where(s => shelfIds.Contains(s.Id))
            //     .ToDictionaryAsync(s => s.Id, s => s.Name);

            // var products = matchedProducts.Select(p => {
            //     var shelfId = (Guid?)locations.FirstOrDefault(l => l.ProductId == p.Id)?.ShelfId;
            //     return new ProductDto(
            //         p.Id,
            //         p.Name,
            //         p.Price,
            //         p.Quantity,
            //         p.CategoryId,
            //         shelfId,
            //         p.Description,
            //         p.ImageUrl,
            //         p.Barcode,
            //         p.StoreId,
            //         p.CreatedAt,
            //         p.UpdatedAt,
            //         p.IsDeleted,
            //         p.DeletedAt,
            //         shelfId != null && shelfNames.TryGetValue(shelfId.Value, out var shelfName) ? shelfName : null
            //     );
            // }).ToList();

            return Results.Ok(matchedProducts);
        }).AllowAnonymous();

        // Get store info and map
        group.MapGet("/stores/{slug}", async (string slug, TindahanDbContext db) =>
        {
            var store = await db.Stores.FirstOrDefaultAsync(s => s.Slug == slug);
            if (store == null) return Results.NotFound("Store not found");

            var shelves = await db.Shelves
                .Where(s => s.StoreId == store.Id)
                .Select(s => new ShelfDto(s.Id, s.Name, s.StoreId, s.X, s.Y, s.Rotation, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.DeletedAt))
                .ToListAsync();

            return Results.Ok(new { Store = store, Shelves = shelves });
        }).AllowAnonymous();
    }
}