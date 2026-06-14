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

            // Alerts (Low Stock)
            var alerts = await db.Products
                .Where(p => p.StoreId == storeId && !p.IsDeleted && p.Quantity <= p.MinStockThreshold)
                .Select(p => new ProductAlertDto(
                    p.Id,
                    p.Name,
                    p.Quantity,
                    p.MinStockThreshold,
                    p.Quantity == 0 ? $"{p.Name} is out of stock!" : $"{p.Name} is running low ({p.Quantity} left)"
                ))
                .ToListAsync();

            var totalInventoryValue = await db.Products
                .Where(p => p.StoreId == storeId && !p.IsDeleted)
                .SumAsync(p => (decimal?)p.Price * p.Quantity) ?? 0m;

            var categories = await db.Categories
                .Where(c => c.StoreId == storeId && !c.IsDeleted)
                .ToListAsync();
            var categoryDict = categories.ToDictionary(c => c.Id, c => c.Name);

            var products = await db.Products
                .Where(p => p.StoreId == storeId)
                .IgnoreQueryFilters()
                .ToListAsync();
            var productCategoryMap = products.ToDictionary(p => p.Id, p => p.CategoryId);

            var mostActiveCategories = entries
                .SelectMany(e => e.Items)
                .GroupBy(i => productCategoryMap.TryGetValue(i.ProductId, out var catId) ? catId : Guid.Empty)
                .Where(g => g.Key != Guid.Empty && categoryDict.ContainsKey(g.Key))
                .Select(g => new ActiveCategoryDto(
                    g.Key,
                    categoryDict[g.Key],
                    g.Sum(i => i.Quantity),
                    g.Sum(i => i.Price * i.Quantity)
                ))
                .OrderByDescending(x => x.Revenue)
                .Take(5)
                .ToList();

            var recentTransactions = entries
                .OrderByDescending(e => e.CreatedAt)
                .Take(5)
                .Select(e => new RecentTransactionDto(
                    e.Id,
                    e.StaffName,
                    e.CustomerName,
                    e.IsCredit,
                    e.TotalAmount,
                    e.CreatedAt,
                    e.Items.Count
                ))
                .ToList();

            var weeklyPerformance = Enumerable.Range(0, 4)
                .Select(i => {
                    var endDate = DateTime.UtcNow.Date.AddDays(-i * 7);
                    var startDate = endDate.AddDays(-7);
                    var amount = entries
                        .Where(e => !e.IsCredit && e.CreatedAt.Date >= startDate && e.CreatedAt.Date < endDate)
                        .Sum(e => e.TotalAmount);
                    return new WeeklyStatDto(startDate, endDate, amount);
                })
                .Reverse()
                .ToList();

            return Results.Ok(new StoreStatsDto(
                totalSales,
                totalCredit,
                totalTransactions,
                performanceChange,
                dailyStats,
                topProducts,
                alerts,
                totalInventoryValue,
                mostActiveCategories,
                recentTransactions,
                weeklyPerformance
            ));
        });
    }
}
