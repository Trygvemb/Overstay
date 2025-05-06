using Microsoft.AspNetCore.OpenApi;
using Microsoft.OpenApi.Models;

namespace Overstay.API.Commons;

/// <summary>
/// Adds a server URL to the OpenAPI document dynamically.
/// </summary>
public sealed class OpenApiServerTransformer(IConfiguration configuration, IWebHostEnvironment environment) : IOpenApiDocumentTransformer
{
    public Task TransformAsync(
        OpenApiDocument document,
        OpenApiDocumentTransformerContext context,
        CancellationToken cancellationToken
    )
    {
        // Check if running in Docker
        var isRunningInDocker = Environment.GetEnvironmentVariable("DOTNET_RUNNING_IN_CONTAINER") == "true";

        // Determine the server URL
        var serverUrl = isRunningInDocker
            ? "http://localhost:5050"
            : environment.IsDevelopment()
                ? configuration["OpenAPI__ServerUrl"] ?? "http://localhost:5093"
                : configuration["OpenAPI__ServerUrl"] ?? "http://localhost:5050";

        document.Servers.Clear(); // Clear any existing servers
        document.Servers.Add(new OpenApiServer { Url = serverUrl });

        return Task.CompletedTask;
    }
}