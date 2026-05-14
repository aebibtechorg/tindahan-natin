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

        group.MapGet("/", async (TindahanDbContext db, Guid storeId, string? q, DateTimeOffset? updatedSince, bool includeDeleted = false) =>
        {
            var categoriesBaseQuery = includeDeleted ? db.Categories.IgnoreQueryFilters() : db.Categories;

            if (string.IsNullOrWhiteSpace(q))
            {
                var query = categoriesBaseQuery
                    .Where(c => c.StoreId == storeId)
                    .AsQueryable();

                if (updatedSince.HasValue)
                {
                    query = query.Where(c => c.UpdatedAt >= updatedSince.Value || c.CreatedAt >= updatedSince.Value);
                }

                return await query
                    .Select(c => new CategoryDto(c.Id, c.Name, c.StoreId, c.CreatedAt, c.UpdatedAt, c.IsDeleted, c.DeletedAt))
                    .ToListAsync();
            }

            var pattern = $"%{q.Trim()}%";

            var categoriesQuery = categoriesBaseQuery
                .Where(c => c.StoreId == storeId && ((c.SearchVector != null && c.SearchVector.Matches(EF.Functions.WebSearchToTsQuery("simple", q))) || EF.Functions.ILike(c.Name, pattern)))
                .AsQueryable();

            if (updatedSince.HasValue)
            {
                categoriesQuery = categoriesQuery.Where(c => c.UpdatedAt >= updatedSince.Value || c.CreatedAt >= updatedSince.Value);
            }

            var categories = await categoriesQuery.ToListAsync();

            return categories.Select(c => new CategoryDto(c.Id, c.Name, c.StoreId, c.CreatedAt, c.UpdatedAt, c.IsDeleted, c.DeletedAt));
        });

        group.MapGet("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            return await db.Categories.FindAsync(id) switch
            {
                Category c => Results.Ok(new CategoryDto(c.Id, c.Name, c.StoreId, c.CreatedAt, c.UpdatedAt, c.IsDeleted, c.DeletedAt)),
                null => Results.NotFound()
            };
        });

        group.MapPost("/", async (CreateCategoryDto dto, TindahanDbContext db) =>
        {
            var cat = new Category { Id = dto.Id ?? Guid.NewGuid(), Name = dto.Name, StoreId = dto.StoreId, CreatedAt = DateTimeOffset.UtcNow, UpdatedAt = DateTimeOffset.UtcNow };
            db.Categories.Add(cat);
            await db.SaveChangesAsync();
            return Results.Created($"/api/categories/{cat.Id}", new CategoryDto(cat.Id, cat.Name, cat.StoreId, cat.CreatedAt, cat.UpdatedAt, cat.IsDeleted, cat.DeletedAt));
        });

        group.MapPut("/{id}", async (Guid id, UpdateCategoryDto dto, TindahanDbContext db) =>
        {
            var cat = await db.Categories.FindAsync(id);
            if (cat is null) return Results.NotFound();
            cat.Name = dto.Name;
            cat.UpdatedAt = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id}", async (Guid id, TindahanDbContext db) =>
        {
            var cat = await db.Categories.FindAsync(id);
            if (cat is null) return Results.NotFound();

            cat.IsDeleted = true;
            cat.DeletedAt = DateTimeOffset.UtcNow;
            cat.UpdatedAt = cat.DeletedAt.Value;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}
