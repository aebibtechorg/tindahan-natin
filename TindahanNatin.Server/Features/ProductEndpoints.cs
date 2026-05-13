using System;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class ProductEndpoints
{
    public static void MapProductEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/products").WithTags("Products");

        group.MapGet("/", async (TindahanDbContext db, Guid storeId) =>
        {
            return await db.Products
                .Where(p => p.StoreId == storeId)
                .Select(p => new ProductDto(p.Id, p.Name, p.Price, p.Quantity, p.CategoryId, p.Description, p.ImageUrl, p.Barcode, p.StoreId))
                .ToListAsync();
        });

        group.MapGet("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            return await db.Products.FindAsync(id) switch
            {
                Product p => Results.Ok(new ProductDto(p.Id, p.Name, p.Price, p.Quantity, p.CategoryId, p.Description, p.ImageUrl, p.Barcode, p.StoreId)),
                null => Results.NotFound()
            };
        });

        group.MapPost("/", async (CreateProductDto dto, TindahanDbContext db) =>
        {
            var product = new Product
            {
                Name = dto.Name,
                Price = dto.Price,
                Quantity = dto.Quantity,
                CategoryId = dto.CategoryId,
                Description = dto.Description,
                Barcode = dto.Barcode,
                StoreId = dto.StoreId
            };

            db.Products.Add(product);
            await db.SaveChangesAsync();

            return Results.Created($"/api/products/{product.Id}", new ProductDto(product.Id, product.Name, product.Price, product.Quantity, product.CategoryId, product.Description, product.ImageUrl, product.Barcode, product.StoreId));
        });

        group.MapPut("/{id}", async (Guid id, UpdateProductDto dto, TindahanDbContext db) =>
        {
            var product = await db.Products.FindAsync(id);
            if (product is null) return Results.NotFound();

            product.Name = dto.Name;
            product.Price = dto.Price;
            product.Quantity = dto.Quantity;
            product.CategoryId = dto.CategoryId;
            product.Description = dto.Description;
            product.Barcode = dto.Barcode;

            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            var product = await db.Products.FindAsync(id);
            if (product is null) return Results.NotFound();

            db.Products.Remove(product);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}