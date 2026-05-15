using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;

namespace TindahanNatin.Server.Features;

public static class UserEndpoints
{
    public static void MapUserEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/user").WithTags("User");

        group.MapDelete("/me", async (HttpContext context, TindahanDbContext db, IConfiguration config, IHttpClientFactory httpClientFactory) =>
        {
            var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? context.User.FindFirst("sub")?.Value;
            var email = context.User.FindFirst(ClaimTypes.Email)?.Value ?? context.User.FindFirst("email")?.Value;

            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            // 1. Delete from Auth0
            var domain = config["Auth0:Domain"];
            var clientId = config["Auth0:ManagementClientId"];
            var clientSecret = config["Auth0:ManagementClientSecret"];

            if (!string.IsNullOrEmpty(clientId) && !string.IsNullOrEmpty(clientSecret) && clientId != "YOUR_MANAGEMENT_CLIENT_ID")
            {
                try
                {
                    var client = httpClientFactory.CreateClient();
                    
                    // Get Access Token
                    var tokenResponse = await client.PostAsJsonAsync($"https://{domain}/oauth/token", new
                    {
                        client_id = clientId,
                        client_secret = clientSecret,
                        audience = $"https://{domain}/api/v2/",
                        grant_type = "client_credentials"
                    });

                    if (tokenResponse.IsSuccessStatusCode)
                    {
                        var tokenData = await tokenResponse.Content.ReadFromJsonAsync<JsonElement>();
                        var accessToken = tokenData.GetProperty("access_token").GetString();

                        // Delete User
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                        var deleteResponse = await client.DeleteAsync($"https://{domain}/api/v2/users/{Uri.EscapeDataString(userId)}");
                        
                        if (!deleteResponse.IsSuccessStatusCode)
                        {
                            var errorBody = await deleteResponse.Content.ReadAsStringAsync();
                            Console.WriteLine($"Auth0 delete failed: {deleteResponse.StatusCode} - {errorBody}");
                        }
                    }
                    else
                    {
                        var errorBody = await tokenResponse.Content.ReadAsStringAsync();
                        Console.WriteLine($"Auth0 token request failed: {tokenResponse.StatusCode} - {errorBody}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error during Auth0 account deletion: {ex.Message}");
                }
            }

            // 2. Delete from Database
            using var transaction = await db.Database.BeginTransactionAsync();
            try
            {
                var store = await db.Stores.FirstOrDefaultAsync(s => s.OwnerId == userId);
                if (store != null)
                {
                    // ProductLocations
                    var locationIds = await db.ProductLocations
                        .Where(pl => db.Shelves.Any(s => s.Id == pl.ShelfId && s.StoreId == store.Id))
                        .Select(pl => pl.Id)
                        .ToListAsync();
                    
                    if (locationIds.Any())
                    {
                        await db.ProductLocations.Where(pl => locationIds.Contains(pl.Id)).ExecuteDeleteAsync();
                    }

                    // Products
                    await db.Products.Where(p => p.StoreId == store.Id).ExecuteDeleteAsync();

                    // Shelves
                    await db.Shelves.Where(s => s.StoreId == store.Id).ExecuteDeleteAsync();

                    // Categories
                    await db.Categories.Where(c => c.StoreId == store.Id).ExecuteDeleteAsync();

                    // Store
                    db.Stores.Remove(store);
                }

                // User record
                if (!string.IsNullOrEmpty(email))
                {
                    var user = await db.Users.FirstOrDefaultAsync(u => u.Email == email);
                    if (user != null)
                    {
                        db.Users.Remove(user);
                    }
                }

                await db.SaveChangesAsync();
                await transaction.CommitAsync();
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return Results.Problem($"Failed to delete user data from database: {ex.Message}");
            }

            return Results.NoContent();
        }).RequireAuthorization();
    }
}
