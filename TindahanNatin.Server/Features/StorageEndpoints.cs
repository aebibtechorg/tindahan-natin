using Minio;
using Minio.DataModel.Args;

namespace TindahanNatin.Server.Features;

public static class StorageEndpoints
{
    public static void MapStorageEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/storage").WithTags("Storage");

        group.MapPost("/upload", async (IFormFile file, IMinioClient minio) =>
        {
            var bucketName = "products";
            var objectName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";

            // Ensure bucket exists
            var beArgs = new BucketExistsArgs().WithBucket(bucketName);
            if (!await minio.BucketExistsAsync(beArgs))
            {
                var mbArgs = new MakeBucketArgs().WithBucket(bucketName);
                await minio.MakeBucketAsync(mbArgs);
            }

            using var stream = file.OpenReadStream();
            var putObjectArgs = new PutObjectArgs()
                .WithBucket(bucketName)
                .WithObject(objectName)
                .WithStreamData(stream)
                .WithObjectSize(file.Length)
                .WithContentType(file.ContentType);

            await minio.PutObjectAsync(putObjectArgs);

            // In a real app, you'd return a URL that goes through a CDN or a signed URL
            // For now, return the object name or a local dev URL
            return Results.Ok(new { Url = $"/api/storage/files/{bucketName}/{objectName}" });
        }).DisableAntiforgery();

        group.MapGet("/files/{bucket}/{file}", async (string bucket, string file, IMinioClient minio) =>
        {
            var memoryStream = new MemoryStream();
            var getObjectArgs = new GetObjectArgs()
                .WithBucket(bucket)
                .WithObject(file)
                .WithCallbackStream(s => s.CopyTo(memoryStream));

            await minio.GetObjectAsync(getObjectArgs);
            memoryStream.Position = 0;
            return Results.File(memoryStream, "application/octet-stream");
        });
    }
}