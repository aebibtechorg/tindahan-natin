using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using Microsoft.Extensions.DependencyInjection;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Models;
using TindahanNatin.Server.Features;

var builder = WebApplication.CreateBuilder(args);

var corsPolicy = "AllowStore";
var corsOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? Array.Empty<string>();

builder.Services.AddCors(o =>
{
    o.AddPolicy(corsPolicy, builder =>
    {
        builder.WithOrigins(corsOrigins)
            .WithMethods("GET");
    });
});

// Add service defaults & Aspire client integrations.
builder.AddServiceDefaults();
builder.AddRedisClientBuilder("cache")
    .WithOutputCache();

builder.AddNpgsqlDbContext<TindahanDbContext>("tindahandb");
builder.AddMinioClient("minio");

// Add services to the container.
builder.Services.AddProblemDetails();
builder.Services.AddHttpClient();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddAuthentication()
    .AddJwtBearer(options =>
    {
        options.Authority = $"https://{builder.Configuration["Auth0:Domain"]}/";
        options.Audience = builder.Configuration["Auth0:Audience"];
    });

builder.Services.AddAuthorization();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseCors(corsPolicy);

app.UseAuthentication();
app.UseAuthorization();

app.MapProductEndpoints();
app.MapStorageEndpoints();
app.MapMapEndpoints();
app.MapStoreEndpoints();
app.MapUserEndpoints();
app.MapPublicEndpoints();
app.MapCategoryEndpoints();

app.Use(async (context, next) =>
{
    if (context.User.Identity?.IsAuthenticated == true)
    {
        var userId = context.User.GetUserId();
        var name = context.User.FindFirst("name")?.Value ?? string.Empty;
        var email = context.User.FindFirst("email")?.Value ?? string.Empty;

        if (!string.IsNullOrEmpty(userId))
        {
            try
            {
                var db = context.RequestServices.GetRequiredService<TindahanDbContext>();

                // Ensure a `User` record exists (mapped by email). Default new users to StoreOwner role.
                if (!string.IsNullOrEmpty(email))
                {
                    var existingUser = await db.Users.FirstOrDefaultAsync(u => u.Email == email);
                    if (existingUser == null)
                    {
                        var newUser = new User
                        {
                            Name = name ?? string.Empty,
                            Email = email,
                            Role = "StoreOwner"
                        };
                        db.Users.Add(newUser);
                        await db.SaveChangesAsync();
                    }
                }

                // Ensure the owner has a Store. We store the identity provider id (sub) in Store.OwnerId.
                var existingStore = await db.Stores.FirstOrDefaultAsync(s => s.OwnerId == userId);
                if (existingStore == null)
                {
                    // Build a readable slug from name, fallback to a short guid if empty.
                    string baseSlug;
                    if (!string.IsNullOrWhiteSpace(name))
                    {
                        baseSlug = name.ToLowerInvariant();
                        baseSlug = Regex.Replace(baseSlug, "[^a-z0-9\\s-]", string.Empty);
                        baseSlug = Regex.Replace(baseSlug, "\\s+", "-").Trim('-');
                        if (string.IsNullOrWhiteSpace(baseSlug)) baseSlug = $"store-{Guid.NewGuid():N}".Substring(0, 8);
                    }
                    else
                    {
                        baseSlug = $"store-{Guid.NewGuid():N}".Substring(0, 8);
                    }

                    var slug = baseSlug;
                    var suffix = 1;
                    while (await db.Stores.AnyAsync(s => s.Slug == slug))
                    {
                        slug = $"{baseSlug}-{suffix++}";
                    }

                    var storeName = !string.IsNullOrWhiteSpace(name) ? $"{name}'s Store" : "My Store";

                    var store = new Store
                    {
                        Name = storeName,
                        Slug = slug,
                        OwnerId = userId
                    };
                    db.Stores.Add(store);
                    await db.SaveChangesAsync();
                }
            }
            catch
            {
                // Silence any DB errors here to avoid breaking requests during auth.
            }
        }
    }
    await next();
});

app.UseOutputCache();

string[] summaries = ["Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"];

var api = app.MapGroup("/api");
api.MapGet("weatherforecast", () =>
{
    var forecast = Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.CacheOutput(p => p.Expire(TimeSpan.FromSeconds(5)))
.WithName("GetWeatherForecast");

app.MapDefaultEndpoints();

app.UseFileServer();

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}