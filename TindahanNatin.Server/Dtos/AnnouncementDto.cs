namespace TindahanNatin.Server.Dtos;

public record AnnouncementDto(
    Guid Id,
    string Title,
    string Message,
    string Type,
    DateTimeOffset CreatedAt,
    DateTimeOffset? StartsAt = null,
    DateTimeOffset? EndsAt = null
);

public record CreateAnnouncementDto(
    string Title,
    string Message,
    string Type,
    DateTimeOffset? StartsAt = null,
    DateTimeOffset? EndsAt = null
);
