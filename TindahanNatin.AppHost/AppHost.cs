var builder = DistributedApplication.CreateBuilder(args);

var frontendPort = 8000;

var cache = builder.AddRedis("cache")
    .WithLifetime(ContainerLifetime.Persistent);

var postgres = builder.AddPostgres("postgres")
    .WithDataVolume()
    .WithLifetime(ContainerLifetime.Persistent)
    .WithPgAdmin(c =>
    {
        c.WithLifetime(ContainerLifetime.Persistent);
        c.WithHostPort(7999);
    });

var db = postgres.AddDatabase("tindahandb");
var minio = builder.AddMinioContainer("minio")
    .WithDataVolume()
    .WithLifetime(ContainerLifetime.Persistent);

var server = builder.AddProject<Projects.TindahanNatin_Server>("server")
    .WithEnvironment("ASPNETCORE_ENVIRONMENT", "Development")
    .WithEnvironment("Auth0__Domain", builder.Configuration["Auth0:Domain"] ?? builder.Configuration["AUTH0_DOMAIN"])
    .WithEnvironment("Auth0__Audience", builder.Configuration["Auth0:Audience"] ?? builder.Configuration["AUTH0_AUDIENCE"])
    .WithEnvironment("Auth0__ManagementClientId", builder.Configuration["Auth0:ManagementClientId"] ?? builder.Configuration["AUTH0_MANAGEMENT_CLIENT_ID"])
    .WithEnvironment("Auth0__ManagementClientSecret", builder.Configuration["Auth0:ManagementClientSecret"] ?? builder.Configuration["AUTH0_MANAGEMENT_CLIENT_SECRET"]);
server.WithReference(cache);
server.WithReference(db);
server.WithReference(minio);
server.WithHttpHealthCheck("/health");
server.WithExternalHttpEndpoints();

var landing = builder.AddJavaScriptApp("landing", "../landing")
    .WithHttpEndpoint(env: "PORT", targetPort: 8001, isProxied: false)
    .WithExternalHttpEndpoints()
    .WithReference(server)
    .WithEnvironment("AUTH_CLIENT_ID", builder.Configuration["Auth0:LandingClientId"] ?? builder.Configuration["AUTH0_LANDING_CLIENT_ID"])
    .WithEnvironment("AUTH_CLIENT_SECRET", builder.Configuration["Auth0:LandingClientSecret"] ?? builder.Configuration["AUTH0_LANDING_CLIENT_SECRET"])
    .WithEnvironment("AUTH_ISSUER", $"https://{builder.Configuration["Auth0:Domain"] ?? builder.Configuration["AUTH0_DOMAIN"]}/")
    .WithEnvironment("AUTH_AUDIENCE", builder.Configuration["Auth0:Audience"] ?? builder.Configuration["AUTH0_AUDIENCE"])
    .WithEnvironment("AUTH_SECRET", builder.Configuration["Auth0:Secret"] ?? builder.Configuration["AUTH0_SECRET"] ?? "a-very-secret-key-at-least-32-chars-long")
    .WithEnvironment("AUTH_TRUST_HOST", "true");

server.WithEnvironment(e =>
{
    e.EnvironmentVariables.Add("Cors__AllowedOrigins__0", $"http://localhost:{frontendPort}");
    e.EnvironmentVariables.Add("Cors__AllowedOrigins__1", landing.GetEndpoint("http"));
});

var flutterWeb = builder.AddExecutable("flutter-web", "/bin/bash", "../tindahan_natin");
flutterWeb.WithArgs(ctx => {
	ctx.Args.Add("./scripts/run_flutter.sh");
	ctx.Args.Add("web");
});
flutterWeb.WithReference(server);
flutterWeb.WaitFor(server);
flutterWeb.WithHttpEndpoint(env: "PORT", targetPort: frontendPort, isProxied: false);
flutterWeb.WithEnvironment("SERVER_HTTP", server.GetEndpoint("http"));
flutterWeb.WithEnvironment("PUBLIC_WEB_APP_BASE_URL", flutterWeb.GetEndpoint("http"));
flutterWeb.WithEnvironment("AUTH0_DOMAIN", builder.Configuration["Auth0:Domain"] ?? builder.Configuration["AUTH0_DOMAIN"]);
flutterWeb.WithEnvironment("AUTH0_CLIENT_ID", builder.Configuration["Auth0:ClientId"] ?? builder.Configuration["AUTH0_CLIENT_ID"]);
flutterWeb.WithEnvironment("AUTH0_AUDIENCE", builder.Configuration["Auth0:Audience"] ?? builder.Configuration["AUTH0_AUDIENCE"]);
flutterWeb.WithUrlForEndpoint("http", c => {
    c.Url = "/#/store";
});

builder.Build().Run();