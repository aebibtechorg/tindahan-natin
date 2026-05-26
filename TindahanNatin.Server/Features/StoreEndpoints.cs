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

            return Results.Ok(new StoreDto(store.Id, store.Name, store.Slug, store.OwnerId, store.InviteCode, store.CreatedAt, store.UpdatedAt));
        }).RequireAuthorization();

        group.MapPost("/{id}/invite-code", async (Guid id, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            if (!await db.HasRoleInStoreAsync(userId, id, "Owner", "Manager")) return Results.Forbid();

            var store = await db.Stores.FindAsync(id);
            if (store == null) return Results.NotFound();

            store.InviteCode = Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper();
            store.UpdatedAt = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync();

            return Results.Ok(new { InviteCode = store.InviteCode });
        }).RequireAuthorization();

        group.MapPost("/join", async (JoinStoreDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            if (string.IsNullOrWhiteSpace(dto.InviteCode)) return Results.BadRequest("Invite code is required.");

            var store = await db.Stores.FirstOrDefaultAsync(s => s.InviteCode == dto.InviteCode.ToUpper());
            if (store == null) return Results.NotFound("Invalid invite code.");

            // Check if already a member
            if (await db.StoreMemberships.AnyAsync(sm => sm.StoreId == store.Id && sm.UserId == userId))
            {
                return Results.Conflict("You are already a member of this store.");
            }

            var membership = new StoreMembership
            {
                StoreId = store.Id,
                UserId = userId,
                Role = "Crew"
            };
            db.StoreMemberships.Add(membership);
            await db.SaveChangesAsync();

            return Results.Ok(new { StoreId = store.Id, StoreName = store.Name });
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
                    (sm, s) => new StoreMembershipDto(sm.Id, sm.StoreId, s.Name, s.Slug, sm.Role, s.InviteCode, sm.CreatedAt))
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
