using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using TindahanNatin.Server.Data;
using TindahanNatin.Server.Dtos;
using TindahanNatin.Server.Hubs;
using TindahanNatin.Server.Models;

namespace TindahanNatin.Server.Features;

public static class AnnouncementEndpoints
{
    public static void MapAnnouncementEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/announcements").WithTags("Announcements");

        group.MapGet("/", async (TindahanDbContext db, ILogger<Announcement> logger) =>
        {
            var now = DateTimeOffset.UtcNow;
            var announcements = await db.Announcements
                .Where(a => (!a.StartsAt.HasValue || a.StartsAt <= now) && (!a.EndsAt.HasValue || a.EndsAt >= now))
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new AnnouncementDto(a.Id, a.Title, a.Message, a.Type, a.CreatedAt, a.StartsAt, a.EndsAt))
                .ToListAsync();
            
            logger.LogInformation("Fetched {Count} active announcements at {Now}", announcements.Count, now);
            return announcements;
        });

        group.MapPost("/", async (CreateAnnouncementDto dto, TindahanDbContext db, IHubContext<TindahanHub> hubContext) =>
        {
            var announcement = new Announcement
            {
                Title = dto.Title,
                Message = dto.Message,
                Type = dto.Type,
                StartsAt = dto.StartsAt,
                EndsAt = dto.EndsAt
            };

            db.Announcements.Add(announcement);
            await db.SaveChangesAsync();

            var result = new AnnouncementDto(
                announcement.Id,
                announcement.Title,
                announcement.Message,
                announcement.Type,
                announcement.CreatedAt,
                announcement.StartsAt,
                announcement.EndsAt
            );

            await hubContext.Clients.All.SendAsync("ReceiveAnnouncement", result);

            return Results.Created($"/api/announcements/{announcement.Id}", result);
        });
    }
}
