using System;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class StoreEndpoints
{
    public static void MapStoreEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/stores").WithTags("Stores");

        // Get the authenticated user's store
        group.MapGet("/me", async (HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var store = await db.Stores.FirstOrDefaultAsync(s => s.OwnerId == userId);
            if (store == null) return Results.NotFound();

            return Results.Ok(new StoreDto(store.Id, store.Name, store.Slug, store.OwnerId, store.CreatedAt, store.UpdatedAt));
        }).RequireAuthorization();

        // Update the authenticated user's store (e.g., name)
        group.MapPut("/me", async (UpdateStoreDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var store = await db.Stores.FirstOrDefaultAsync(s => s.OwnerId == userId);
            if (store == null) return Results.NotFound();

            store.Name = dto.Name;
            store.UpdatedAt = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync();
            return Results.NoContent();
        }).RequireAuthorization();
    }
}
