using System;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

using Microsoft.AspNetCore.SignalR;
using TindahanNatin.Server.Hubs;

namespace TindahanNatin.Server.Features;

public static class ListaEndpoints
{
    public static void MapListaEndpoints(this IEndpointRouteBuilder routes)
    {
        var publicGroup = routes.MapGroup("/api/public/lista").WithTags("Lista (Public)");

        publicGroup.MapPost("/", async (CreateListaEntryDto dto, TindahanDbContext db, IHubContext<TindahanHub> hubContext) =>
        {
            var store = await db.Stores.FindAsync(dto.StoreId);
            if (store == null) return Results.NotFound("Store not found");

            var entry = new ListaEntry
            {
                Id = Guid.NewGuid(),
                StoreId = dto.StoreId,
                StaffName = dto.StaffName,
                CustomerName = dto.CustomerName,
                IsCredit = dto.IsCredit,
                CreatedAt = DateTimeOffset.UtcNow,
                UpdatedAt = DateTimeOffset.UtcNow
            };

            decimal total = 0;
            foreach (var itemDto in dto.Items)
            {
                var product = await db.Products.FindAsync(itemDto.ProductId);
                if (product == null || product.StoreId != dto.StoreId) continue;

                var item = new ListaItem
                {
                    Id = Guid.NewGuid(),
                    ListaEntryId = entry.Id,
                    ProductId = product.Id,
                    ProductName = product.Name,
                    Quantity = itemDto.Quantity,
                    Price = product.Price
                };
                entry.Items.Add(item);
                total += item.Price * item.Quantity;

                // Deduct from inventory
                product.Quantity -= item.Quantity;
                product.UpdatedAt = DateTimeOffset.UtcNow;
            }

            entry.TotalAmount = total;
            db.ListaEntries.Add(entry);
            await db.SaveChangesAsync();

            await hubContext.Clients.Group(dto.StoreId.ToString()).SendAsync("ListaUpdated", dto.StoreId);

            return Results.Created($"/api/public/lista/{entry.Id}", new ListaEntryDto(
                entry.Id,
                entry.StoreId,
                entry.StaffName,
                entry.CustomerName,
                entry.IsCredit,
                entry.TotalAmount,
                entry.CreatedAt,
                entry.Items.Select(i => new ListaItemDto(i.Id, i.ProductId, i.ProductName, i.Quantity, i.Price)).ToList()
            ));
        }).AllowAnonymous();

        publicGroup.MapGet("/", async (Guid storeId, DateTimeOffset? startDate, DateTimeOffset? endDate, TindahanDbContext db) =>
        {
            var query = db.ListaEntries
                .Where(e => e.StoreId == storeId);

            if (startDate.HasValue) query = query.Where(e => e.CreatedAt >= startDate.Value);
            if (endDate.HasValue) query = query.Where(e => e.CreatedAt <= endDate.Value);

            var entries = await query
                .OrderByDescending(e => e.CreatedAt)
                .Include(e => e.Items)
                .ToListAsync();

            return Results.Ok(entries.Select(entry => new ListaEntryDto(
                entry.Id,
                entry.StoreId,
                entry.StaffName,
                entry.CustomerName,
                entry.IsCredit,
                entry.TotalAmount,
                entry.CreatedAt,
                entry.Items.Select(i => new ListaItemDto(i.Id, i.ProductId, i.ProductName, i.Quantity, i.Price)).ToList()
            )));
        }).AllowAnonymous();

        publicGroup.MapPut("/{id}/toggle-credit", async (Guid id, TindahanDbContext db, IHubContext<TindahanHub> hubContext) =>
        {
            var entry = await db.ListaEntries.FindAsync(id);
            if (entry == null) return Results.NotFound();

            entry.IsCredit = !entry.IsCredit; // Toggle between paid (false) and unpaid (true)
            entry.UpdatedAt = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync();

            await hubContext.Clients.Group(entry.StoreId.ToString()).SendAsync("ListaUpdated", entry.StoreId);

            return Results.NoContent();
        }).AllowAnonymous();

        var protectedGroup = routes.MapGroup("/api/lista").WithTags("Lista (Protected)").RequireAuthorization();

        protectedGroup.MapGet("/", async (HttpContext context, TindahanDbContext db, Guid storeId, DateTimeOffset? startDate, DateTimeOffset? endDate) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var query = db.ListaEntries
                .Where(e => e.StoreId == storeId);

            if (startDate.HasValue) query = query.Where(e => e.CreatedAt >= startDate.Value);
            if (endDate.HasValue) query = query.Where(e => e.CreatedAt <= endDate.Value);

            var entries = await query
                .OrderByDescending(e => e.CreatedAt)
                .Include(e => e.Items)
                .ToListAsync();

            return Results.Ok(entries.Select(entry => new ListaEntryDto(
                entry.Id,
                entry.StoreId,
                entry.StaffName,
                entry.CustomerName,
                entry.IsCredit,
                entry.TotalAmount,
                entry.CreatedAt,
                entry.Items.Select(i => new ListaItemDto(i.Id, i.ProductId, i.ProductName, i.Quantity, i.Price)).ToList()
            )));
        });

        protectedGroup.MapDelete("/{id}", async (Guid id, HttpContext context, TindahanDbContext db, IHubContext<TindahanHub> hubContext) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            var entry = await db.ListaEntries.FindAsync(id);
            if (entry == null) return Results.NotFound();

            if (!await db.OwnsStoreAsync(userId, entry.StoreId)) return Results.Forbid();

            var storeId = entry.StoreId;
            db.ListaEntries.Remove(entry);
            await db.SaveChangesAsync();

            await hubContext.Clients.Group(storeId.ToString()).SendAsync("ListaUpdated", storeId);

            return Results.NoContent();
        });
    }
}
