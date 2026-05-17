using System;
using Microsoft.EntityFrameworkCore;
using Npgsql.EntityFrameworkCore.PostgreSQL;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class ProductEndpoints
{
    public static void MapProductEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/products").WithTags("Products").RequireAuthorization();

        group.MapGet("/", async (HttpContext context, TindahanDbContext db, Guid storeId, Guid? categoryId, Guid? shelfId, string? q, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var productsBaseQuery = db.OwnedProducts(userId, includeDeleted);

            // If no query provided, use regular LINQ path.
            if (string.IsNullOrWhiteSpace(q))
            {
                var plainQuery = productsBaseQuery.Where(p => p.StoreId == storeId);
                if (categoryId.HasValue)
                {
                    plainQuery = plainQuery.Where(p => p.CategoryId == categoryId.Value);
                }
                if (shelfId.HasValue)
                {
                    plainQuery = plainQuery.Where(p => p.ShelfId == shelfId.Value);
                }
                if (updatedSince.HasValue)
                {
                    plainQuery = plainQuery.Where(p => p.UpdatedAt >= updatedSince.Value || p.CreatedAt >= updatedSince.Value);
                }

                var plainProducts = await plainQuery.ToListAsync();

                return Results.Ok(plainProducts
                    .Select(p => new ProductDto(p.Id, p.Name, p.Price, p.Quantity, p.CategoryId, p.ShelfId, p.Description, p.ImageUrl, p.Barcode, p.StoreId, p.CreatedAt, p.UpdatedAt, p.IsDeleted, p.DeletedAt)));
            }

            var productsQuery = productsBaseQuery.Where(p => p.StoreId == storeId);
            if (categoryId.HasValue)
            {
                productsQuery = productsQuery.Where(p => p.CategoryId == categoryId.Value);
            }
            if (shelfId.HasValue)
            {
                productsQuery = productsQuery.Where(p => p.ShelfId == shelfId.Value);
            }
            if (updatedSince.HasValue)
            {
                productsQuery = productsQuery.Where(p => p.UpdatedAt >= updatedSince.Value || p.CreatedAt >= updatedSince.Value);
            }

            var pattern = $"%{q.Trim()}%";

            productsQuery = productsQuery.Where(p =>
                (p.SearchVector != null && p.SearchVector.Matches(EF.Functions.WebSearchToTsQuery("simple", q))) ||
                EF.Functions.ILike(p.Name, pattern) ||
                EF.Functions.ILike(p.Description ?? string.Empty, pattern) ||
                EF.Functions.ILike(p.Barcode ?? string.Empty, pattern));

            var products = await productsQuery.ToListAsync();

            return Results.Ok(products.Select(p => new ProductDto(p.Id, p.Name, p.Price, p.Quantity, p.CategoryId, p.ShelfId, p.Description, p.ImageUrl, p.Barcode, p.StoreId, p.CreatedAt, p.UpdatedAt, p.IsDeleted, p.DeletedAt)));
        });

        group.MapGet("/{id}", async (Guid id, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            return await db.OwnedProducts(userId).FirstOrDefaultAsync(p => p.Id == id) switch
            {
                Product p => Results.Ok(new ProductDto(p.Id, p.Name, p.Price, p.Quantity, p.CategoryId, p.ShelfId, p.Description, p.ImageUrl, p.Barcode, p.StoreId, p.CreatedAt, p.UpdatedAt, p.IsDeleted, p.DeletedAt)),
                null => Results.NotFound()
            };
        });

        group.MapPost("/", async (CreateProductDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, dto.StoreId)) return Results.Forbid();
            if (!await db.OwnedCategories(userId).AnyAsync(c => c.Id == dto.CategoryId && c.StoreId == dto.StoreId)) return Results.BadRequest("Category does not belong to the authenticated user's store.");
            if (dto.ShelfId.HasValue && !await db.OwnedShelves(userId).AnyAsync(s => s.Id == dto.ShelfId.Value && s.StoreId == dto.StoreId)) return Results.BadRequest("Shelf does not belong to the authenticated user's store.");

            var product = new Product
            {
                Id = dto.Id ?? Guid.NewGuid(),
                Name = dto.Name,
                Price = dto.Price,
                Quantity = dto.Quantity,
                CategoryId = dto.CategoryId,
                ShelfId = dto.ShelfId,
                Description = dto.Description,
                ImageUrl = dto.ImageUrl,
                Barcode = dto.Barcode,
                StoreId = dto.StoreId,
                CreatedAt = DateTimeOffset.UtcNow,
                UpdatedAt = DateTimeOffset.UtcNow
            };

            db.Products.Add(product);
            await db.SaveChangesAsync();

            return Results.Created($"/api/products/{product.Id}", new ProductDto(product.Id, product.Name, product.Price, product.Quantity, product.CategoryId, product.ShelfId, product.Description, product.ImageUrl, product.Barcode, product.StoreId, product.CreatedAt, product.UpdatedAt, product.IsDeleted, product.DeletedAt));
        });

        group.MapPut("/{id}", async (Guid id, UpdateProductDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var product = await db.OwnedProducts(userId).FirstOrDefaultAsync(p => p.Id == id);
            if (product is null) return Results.NotFound();
            if (!await db.OwnedCategories(userId).AnyAsync(c => c.Id == dto.CategoryId && c.StoreId == product.StoreId)) return Results.BadRequest("Category does not belong to the authenticated user's store.");
            if (dto.ShelfId.HasValue && !await db.OwnedShelves(userId).AnyAsync(s => s.Id == dto.ShelfId.Value && s.StoreId == product.StoreId)) return Results.BadRequest("Shelf does not belong to the authenticated user's store.");

            product.Name = dto.Name;
            product.Price = dto.Price;
            product.Quantity = dto.Quantity;
            product.CategoryId = dto.CategoryId;
            product.ShelfId = dto.ShelfId;
            product.Description = dto.Description;
            product.ImageUrl = dto.ImageUrl;
            product.Barcode = dto.Barcode;
            product.UpdatedAt = DateTimeOffset.UtcNow;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id}", async (Guid id, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var product = await db.OwnedProducts(userId).FirstOrDefaultAsync(p => p.Id == id);
            if (product is null) return Results.NotFound();

            product.IsDeleted = true;
            product.DeletedAt = DateTimeOffset.UtcNow;
            product.UpdatedAt = product.DeletedAt.Value;

            var locations = await db.OwnedProductLocations(userId).Where(pl => pl.ProductId == id).ToListAsync();
            foreach (var location in locations)
            {
                location.IsDeleted = true;
                location.DeletedAt = product.DeletedAt;
                location.UpdatedAt = product.DeletedAt.Value;
            }

            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}