using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

internal static class StoreOwnership
{
    public static string? GetUserId(this ClaimsPrincipal user) =>
        user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value;

    public static IQueryable<Store> OwnedStores(this TindahanDbContext db, string userId) =>
        db.Stores.Where(store => store.OwnerId == userId);

    public static IQueryable<Category> OwnedCategories(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var categories = includeDeleted ? db.Categories.IgnoreQueryFilters() : db.Categories;
        var ownedStoreIds = db.OwnedStores(userId).Select(store => store.Id);
        return categories.Where(category => ownedStoreIds.Contains(category.StoreId));
    }

    public static IQueryable<Product> OwnedProducts(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var products = includeDeleted ? db.Products.IgnoreQueryFilters() : db.Products;
        var ownedStoreIds = db.OwnedStores(userId).Select(store => store.Id);
        return products.Where(product => ownedStoreIds.Contains(product.StoreId));
    }

    public static IQueryable<Shelf> OwnedShelves(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var shelves = includeDeleted ? db.Shelves.IgnoreQueryFilters() : db.Shelves;
        var ownedStoreIds = db.OwnedStores(userId).Select(store => store.Id);
        return shelves.Where(shelf => ownedStoreIds.Contains(shelf.StoreId));
    }

    public static IQueryable<ProductLocation> OwnedProductLocations(this TindahanDbContext db, string userId, bool includeDeleted = false)
    {
        var locations = includeDeleted ? db.ProductLocations.IgnoreQueryFilters() : db.ProductLocations;
        var ownedShelfIds = db.OwnedShelves(userId, includeDeleted).Select(shelf => shelf.Id);
        return locations.Where(location => ownedShelfIds.Contains(location.ShelfId));
    }

    public static Task<bool> OwnsStoreAsync(this TindahanDbContext db, string userId, Guid storeId) =>
        db.OwnedStores(userId).AnyAsync(store => store.Id == storeId);
}