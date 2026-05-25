using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

internal static class StoreOwnership
{
    public static string? GetUserId(this ClaimsPrincipal user) =>
        user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value;

    public static IQueryable<Store> AccessibleStores(this TindahanDbContext db, string userId) =>
        db.StoreMemberships
          .Where(sm => sm.UserId == userId)
          .Join(db.Stores, sm => sm.StoreId, s => s.Id, (sm, s) => s);

    public static IQueryable<Store> OwnedStores(this TindahanDbContext db, string userId) =>
        db.StoreMemberships
          .Where(sm => sm.UserId == userId && sm.Role == "Owner")
          .Join(db.Stores, sm => sm.StoreId, s => s.Id, (sm, s) => s);

    public static IQueryable<Category> OwnedCategories(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var categories = includeDeleted ? db.Categories.IgnoreQueryFilters() : db.Categories;
        var accessibleStoreIds = db.AccessibleStores(userId).Select(store => store.Id);
        return categories.Where(category => accessibleStoreIds.Contains(category.StoreId));
    }

    public static IQueryable<Product> OwnedProducts(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var products = includeDeleted ? db.Products.IgnoreQueryFilters() : db.Products;
        var accessibleStoreIds = db.AccessibleStores(userId).Select(store => store.Id);
        return products.Where(product => accessibleStoreIds.Contains(product.StoreId));
    }

    public static IQueryable<Shelf> OwnedShelves(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var shelves = includeDeleted ? db.Shelves.IgnoreQueryFilters() : db.Shelves;
        var accessibleStoreIds = db.AccessibleStores(userId).Select(store => store.Id);
        return shelves.Where(shelf => accessibleStoreIds.Contains(shelf.StoreId));
    }

    public static IQueryable<ProductLocation> OwnedProductLocations(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var locations = includeDeleted ? db.ProductLocations.IgnoreQueryFilters() : db.ProductLocations;
        var accessibleShelfIds = db.OwnedShelves(userId, includeDeleted).Select(shelf => shelf.Id);
        return locations.Where(location => accessibleShelfIds.Contains(location.ShelfId));
    }

    public static Task<bool> OwnsStoreAsync(this TindahanDbContext db, string userId, Guid storeId) =>
        db.StoreMemberships.AnyAsync(sm => sm.UserId == userId && sm.StoreId == storeId && (sm.Role == "Owner" || sm.Role == "Manager"));

    public static Task<bool> HasRoleInStoreAsync(this TindahanDbContext db, string userId, Guid storeId, params string[] roles) =>
        db.StoreMemberships.AnyAsync(sm => sm.UserId == userId && sm.StoreId == storeId && roles.Contains(sm.Role));
}