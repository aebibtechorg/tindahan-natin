using System;
using Microsoft.EntityFrameworkCore;
using Npgsql.EntityFrameworkCore.PostgreSQL;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class CategoryEndpoints
{
    public static void MapCategoryEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/categories").WithTags("Categories");

        group.MapGet("/", async (TindahanDbContext db, Guid storeId, string? q) =>
        {
            if (string.IsNullOrWhiteSpace(q))
            {
                return await db.Categories
                    .Where(c => c.StoreId == storeId)
                    .Select(c => new CategoryDto(c.Id, c.Name, c.StoreId))
                    .ToListAsync();
            }

            var pattern = $"%{q.Trim()}%";

            var categories = await db.Categories
                .Where(c => c.StoreId == storeId && ((c.SearchVector != null && c.SearchVector.Matches(EF.Functions.WebSearchToTsQuery("simple", q))) || EF.Functions.ILike(c.Name, pattern)))
                .ToListAsync();

            return categories.Select(c => new CategoryDto(c.Id, c.Name, c.StoreId));
        });

        group.MapGet("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            return await db.Categories.FindAsync(id) switch
            {
                Category c => Results.Ok(new CategoryDto(c.Id, c.Name, c.StoreId)),
                null => Results.NotFound()
            };
        });

        group.MapPost("/", async (CreateCategoryDto dto, TindahanDbContext db) =>
        {
            var cat = new Category { Name = dto.Name, StoreId = dto.StoreId };
            db.Categories.Add(cat);
            await db.SaveChangesAsync();
            return Results.Created($"/api/categories/{cat.Id}", new CategoryDto(cat.Id, cat.Name, cat.StoreId));
        });

        group.MapPut("/{id}", async (Guid id, UpdateCategoryDto dto, TindahanDbContext db) =>
        {
            var cat = await db.Categories.FindAsync(id);
            if (cat is null) return Results.NotFound();
            cat.Name = dto.Name;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            var cat = await db.Categories.FindAsync(id);
            if (cat is null) return Results.NotFound();
            db.Categories.Remove(cat);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}
