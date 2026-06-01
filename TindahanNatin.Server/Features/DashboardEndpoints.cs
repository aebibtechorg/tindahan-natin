using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;

namespace TindahanNatin.Server.Features;

public static class DashboardEndpoints
{
    public static void MapDashboardEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/dashboard").WithTags("Dashboard").RequireAuthorization();

        group.MapGet("/stats", async (HttpContext context, TindahanDbContext db, Guid storeId) =>
        {
            var userId = context.User.GetUserId();
            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();
            if (!await db.OwnsStoreAsync(userId, storeId)) return Results.Forbid();

            var entries = await db.ListaEntries
                .Where(e => e.StoreId == storeId)
                .Include(e => e.Items)
                .ToListAsync();

            var totalSales = entries.Where(e => !e.IsCredit).Sum(e => e.TotalAmount);
            var totalCredit = entries.Where(e => e.IsCredit).Sum(e => e.TotalAmount);
            var totalTransactions = entries.Count;

            // Calculate performance (last 7 days vs previous 7 days)
            var sevenDaysAgo = DateTime.UtcNow.Date.AddDays(-7);
            var fourteenDaysAgo = DateTime.UtcNow.Date.AddDays(-14);

            var currentWeekSales = entries
                .Where(e => !e.IsCredit && e.CreatedAt >= sevenDaysAgo)
                .Sum(e => e.TotalAmount);

            var previousWeekSales = entries
                .Where(e => !e.IsCredit && e.CreatedAt >= fourteenDaysAgo && e.CreatedAt < sevenDaysAgo)
                .Sum(e => e.TotalAmount);

            double performanceChange = 0;
            if (previousWeekSales > 0)
            {
                performanceChange = (double)((currentWeekSales - previousWeekSales) / previousWeekSales * 100);
            }
            else if (currentWeekSales > 0)
            {
                performanceChange = 100;
            }

            // Daily performance for last 7 days
            var last7Days = Enumerable.Range(0, 7)
                .Select(i => DateTime.UtcNow.Date.AddDays(-i))
                .Reverse()
                .ToList();

            var dailyStats = last7Days.Select(date => new DailyStatDto(
                date,
                entries.Where(e => e.CreatedAt.Date == date).Sum(e => e.TotalAmount)
            )).ToList();

            // Top products
            var topProducts = entries
                .SelectMany(e => e.Items)
                .GroupBy(i => new { i.ProductId, i.ProductName })
                .Select(g => new { 
                    Id = g.Key.ProductId, 
                    Name = g.Key.ProductName, 
                    Qty = g.Sum(i => i.Quantity), 
                    Rev = g.Sum(i => i.Price * i.Quantity) 
                })
                .OrderByDescending(x => x.Qty)
                .Take(5)
                .Select(x => new TopProductDto(x.Id, x.Name, x.Qty, x.Rev))
                .ToList();

            return Results.Ok(new StoreStatsDto(
                totalSales,
                totalCredit,
                totalTransactions,
                performanceChange,
                dailyStats,
                topProducts
            ));
        });
    }
}
