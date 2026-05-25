using System;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class SaleEndpoints
{
    public static void MapSaleEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/sales").WithTags("Sales").RequireAuthorization();

        group.MapGet("/", async (HttpContext context, TindahanDbContext db, Guid storeId, DateTimeOffset? from, DateTimeOffset? to) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var query = db.Sales.Where(s => s.StoreId == storeId);

            if (from.HasValue) query = query.Where(s => s.CreatedAt >= from.Value);
            if (to.HasValue) query = query.Where(s => s.CreatedAt <= to.Value);

            var sales = await query
                .OrderByDescending(s => s.CreatedAt)
                .Select(s => new SaleDto(s.Id, s.StoreId, s.ProductId, s.ProductName, s.PriceAtSale, s.Quantity, s.TotalPrice, s.IsCredit, s.CustomerName, s.CreatedAt))
                .ToListAsync();

            return Results.Ok(sales);
        });

        group.MapPost("/", async (CreateSaleDto dto, HttpContext context, TindahanDbContext db) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, dto.StoreId)) return Results.Forbid();

            var sale = new Sale
            {
                Id = dto.Id ?? Guid.NewGuid(),
                StoreId = dto.StoreId,
                ProductId = dto.ProductId,
                ProductName = dto.ProductName,
                PriceAtSale = dto.PriceAtSale,
                Quantity = dto.Quantity,
                TotalPrice = dto.TotalPrice,
                IsCredit = dto.IsCredit,
                CustomerName = dto.CustomerName,
                CreatedAt = DateTimeOffset.UtcNow
            };

            db.Sales.Add(sale);

            // Update product quantity if linked
            if (dto.ProductId.HasValue)
            {
                var product = await db.Products.FindAsync(dto.ProductId.Value);
                if (product != null && product.StoreId == dto.StoreId)
                {
                    product.Quantity -= dto.Quantity;
                    product.UpdatedAt = DateTimeOffset.UtcNow;
                }
            }

            await db.SaveChangesAsync();

            return Results.Created($"/api/sales/{sale.Id}", new SaleDto(sale.Id, sale.StoreId, sale.ProductId, sale.ProductName, sale.PriceAtSale, sale.Quantity, sale.TotalPrice, sale.IsCredit, sale.CustomerName, sale.CreatedAt));
        });
    }
}
