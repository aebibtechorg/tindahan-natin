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

        group.MapDelete("/me", async (HttpContext context, TindahanDbContext db, IServiceScopeFactory scopeFactory, IConfiguration config, IHttpClientFactory httpClientFactory) =>
        {
            var userId = context.User.GetUserId();
            var email = context.User.FindFirst(ClaimTypes.Email)?.Value ?? context.User.FindFirst("email")?.Value;

            if (string.IsNullOrEmpty(userId)) return Results.Unauthorized();

            // 1. Delete from Database (inside EF execution strategy for retriable transactions)
            try
            {
                var executionStrategy = db.Database.CreateExecutionStrategy();

                await executionStrategy.ExecuteAsync(async () =>
                {
                    using var scope = scopeFactory.CreateScope();
                    var retryDb = scope.ServiceProvider.GetRequiredService<TindahanDbContext>();

                    await using var transaction = await retryDb.Database.BeginTransactionAsync();

                    var store = await retryDb.Stores.FirstOrDefaultAsync(s => s.OwnerId == userId);
                    if (store != null)
                    {
                        // ProductLocations
                        var locationIds = await retryDb.ProductLocations
                            .Where(pl => retryDb.Shelves.Any(s => s.Id == pl.ShelfId && s.StoreId == store.Id))
                            .Select(pl => pl.Id)
                            .ToListAsync();

                        if (locationIds.Any())
                        {
                            await retryDb.ProductLocations.Where(pl => locationIds.Contains(pl.Id)).ExecuteDeleteAsync();
                        }

                        // Products
                        await retryDb.Products.Where(p => p.StoreId == store.Id).ExecuteDeleteAsync();

                        // Shelves
                        await retryDb.Shelves.Where(s => s.StoreId == store.Id).ExecuteDeleteAsync();

                        // Categories
                        await retryDb.Categories.Where(c => c.StoreId == store.Id).ExecuteDeleteAsync();

                        // Store
                        retryDb.Stores.Remove(store);
                    }

                    // User record
                    if (!string.IsNullOrEmpty(email))
                    {
                        var user = await retryDb.Users.FirstOrDefaultAsync(u => u.Email == email);
                        if (user != null)
                        {
                            retryDb.Users.Remove(user);
                        }
                    }

                    await retryDb.SaveChangesAsync();
                    await transaction.CommitAsync();
                });
            }
            catch (Exception ex)
            {
                return Results.Problem($"Failed to delete user data from database: {ex.Message}");
            }

            // 2. Delete from Auth0 after local data has been removed
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

            return Results.NoContent();
        }).RequireAuthorization();
    }
}
