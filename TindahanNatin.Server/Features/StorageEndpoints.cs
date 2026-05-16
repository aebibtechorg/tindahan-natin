using Minio;
using Minio.DataModel.Args;
using Minio.Exceptions;

namespace TindahanNatin.Server.Features;

public static class StorageEndpoints
{
    public static void MapStorageEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/storage").WithTags("Storage");

        group.MapPost("/upload", async (
            IFormFile file,
            IMinioClient minio,
            IConfiguration configuration,
            IHostEnvironment environment,
            ILoggerFactory loggerFactory) =>
        {
            var logger = loggerFactory.CreateLogger("StorageEndpoints");
            var bucketName = GetBucketName(configuration);
            var objectName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";

            if (environment.IsDevelopment())
            {
                await EnsureBucketExistsAsync(minio, bucketName);
            }

            using var stream = file.OpenReadStream();
            var putObjectArgs = new PutObjectArgs()
                .WithBucket(bucketName)
                .WithObject(objectName)
                .WithStreamData(stream)
                .WithObjectSize(file.Length)
                .WithContentType(file.ContentType);

            try
            {
                await minio.PutObjectAsync(putObjectArgs);
            }
            catch (BucketNotFoundException ex)
            {
                logger.LogError(ex, "Upload failed because bucket {BucketName} was not found.", bucketName);
                return Results.Problem(
                    title: "Storage bucket not found",
                    detail: "The configured object storage bucket does not exist.",
                    statusCode: StatusCodes.Status503ServiceUnavailable);
            }
            catch (MinioException ex)
            {
                logger.LogError(ex, "Upload failed for object {ObjectName} in bucket {BucketName}.", objectName, bucketName);
                return Results.Problem(
                    title: "Storage upload failed",
                    detail: "Object storage rejected the upload. Check the storage endpoint, credentials, and bucket configuration.",
                    statusCode: StatusCodes.Status503ServiceUnavailable);
            }

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

    private static string GetBucketName(IConfiguration configuration)
    {
        return configuration["Storage:BucketName"]
            ?? configuration["R2_BUCKET_NAME"]
            ?? "products";
    }

    private static async Task EnsureBucketExistsAsync(IMinioClient minio, string bucketName)
    {
        var bucketExistsArgs = new BucketExistsArgs().WithBucket(bucketName);
        if (await minio.BucketExistsAsync(bucketExistsArgs))
        {
            return;
        }

        var makeBucketArgs = new MakeBucketArgs().WithBucket(bucketName);
        await minio.MakeBucketAsync(makeBucketArgs);
    }
}