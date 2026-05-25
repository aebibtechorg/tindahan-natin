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

            var store = await db.OwnedStores(userId).FirstOrDefaultAsync();
            if (store == null) return Results.NotFound();

            return Results.Ok(new StoreDto(store.Id, store.Name, store.Slug, store.OwnerId, store.CreatedAt, store.UpdatedAt));
        }).RequireAuthorization();

        group.MapGet("/memberships", async (HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var memberships = await db.StoreMemberships
                .Where(sm => sm.UserId == userId)
                .Join(db.Stores,
                    sm => sm.StoreId,
                    s => s.Id,
                    (sm, s) => new StoreMembershipDto(sm.Id, sm.StoreId, s.Name, s.Slug, sm.Role, sm.CreatedAt))
                .ToListAsync();

            return Results.Ok(memberships);
        }).RequireAuthorization();

        // Update a specific store
        group.MapPut("/{id}", async (Guid id, UpdateStoreDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            if (!await db.HasRoleInStoreAsync(userId, id, "Owner", "Manager")) return Results.Forbid();

            var store = await db.Stores.FindAsync(id);
            if (store == null) return Results.NotFound();

            store.Name = dto.Name;
            store.UpdatedAt = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync();
            return Results.NoContent();
        }).RequireAuthorization();
    }
}
