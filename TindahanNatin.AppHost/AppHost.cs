using Aspire.Hosting;

var builder = DistributedApplication.CreateBuilder(args);

var frontendPort = 8000;

var cache = builder.AddRedis("cache");
var postgres = builder.AddPostgres("postgres").WithDataVolume().WithPgAdmin();

var db = postgres.AddDatabase("tindahandb");
var minio = builder.AddMinioContainer("minio").WithDataVolume();

var server = builder.AddProject<Projects.TindahanNatin_Server>("server")
    .WithEnvironment("Auth0__Domain", builder.Configuration["Auth0:Domain"])
    .WithEnvironment("Auth0__Audience", builder.Configuration["Auth0:Audience"])
    .WithEnvironment("Auth0__ManagementClientId", builder.Configuration["Auth0:ManagementClientId"])
    .WithEnvironment("Auth0__ManagementClientSecret", builder.Configuration["Auth0:ManagementClientSecret"]);
server.WithReference(cache);
server.WithReference(db);
server.WithReference(minio);
server.WithHttpHealthCheck("/health");
server.WithExternalHttpEndpoints();

var landing = builder.AddJavaScriptApp("landing", "../landing")
    .WithHttpEndpoint(env: "PORT", targetPort: 8001, isProxied: false)
    .WithExternalHttpEndpoints()
    .WithReference(server)
    .WithEnvironment("AUTH_CLIENT_ID", builder.Configuration["Auth0:ClientId"])
    .WithEnvironment("AUTH_CLIENT_SECRET", builder.Configuration["Auth0:ClientSecret"])
    .WithEnvironment("AUTH_ISSUER", $"https://{builder.Configuration["Auth0:Domain"]}/")
    .WithEnvironment("AUTH_AUDIENCE", builder.Configuration["Auth0:Audience"])
    .WithEnvironment("AUTH_SECRET", builder.Configuration["Auth0:Secret"] ?? "a-very-secret-key-at-least-32-chars-long")
    .WithEnvironment("AUTH_TRUST_HOST", "true");

server.WithEnvironment(e =>
{
    e.EnvironmentVariables.Add("Cors__AllowedOrigins__0", $"http://localhost:{frontendPort}");
    e.EnvironmentVariables.Add("Cors__AllowedOrigins__1", landing.GetEndpoint("http"));
});

var apiTunnel = builder.AddDevTunnel("api-tunnel", "tindahannatin-api-tunnel")
    .WithReference(server)
    .WithAnonymousAccess();
    // .WaitFor(server);

// var webfrontend = builder.AddViteApp("webfrontend", "../frontend");
// webfrontend.WithReference(server);
// webfrontend.WaitFor(server);

// Publish existing Vite frontend into the server's wwwroot (if used)
// server.PublishWithContainerFiles(webfrontend, "wwwroot");

// Register Flutter dev runners (web + android) as executable resources.
// These run the small wrapper script which constructs the appropriate
// `flutter run` command using environment variables injected by Aspire.
var flutterWeb = builder.AddExecutable("flutter-web", "/bin/bash", "../tindahan_natin");
flutterWeb.WithArgs(ctx => {
	ctx.Args.Add("./scripts/run_flutter.sh");
	ctx.Args.Add("web");
});
flutterWeb.WithReference(server);
flutterWeb.WaitFor(server);
flutterWeb.WithHttpEndpoint(env: "PORT", targetPort: frontendPort, isProxied: false);
flutterWeb.WithUrlForEndpoint("http", c => {
    c.Url = "/#/store";
});

// var flutterAndroid = builder.AddExecutable("flutter-android", "/bin/bash", "../tindahan_natin");
// flutterAndroid.WithArgs(ctx => {
// 	ctx.Args.Add("./scripts/run_flutter.sh");
// 	ctx.Args.Add("android");
// });
// flutterAndroid.WaitFor(apiTunnel);
// flutterAndroid.WithEnvironment(e => {
//     e.EnvironmentVariables.Add("SERVER_HTTP", apiTunnel.GetEndpoint("https"));
// });

builder.Build().Run();