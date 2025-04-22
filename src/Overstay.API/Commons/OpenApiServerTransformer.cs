using Microsoft.AspNetCore.OpenApi;
using Microsoft.OpenApi.Models;

namespace Overstay.API.Commons;

/// <summary>
/// Adds a server URL to the OpenAPI document dynamically.
/// </summary>
public sealed class OpenApiServerTransformer(IConfiguration configuration) : IOpenApiDocumentTransformer
{
    public Task TransformAsync(
        OpenApiDocument document,
        OpenApiDocumentTransformerContext context,
        CancellationToken cancellationToken
    )
    {
        // Fetch the server URL from the configuration or default to localhost:5050
        var serverUrl = configuration["OpenAPI__ServerUrl"] ?? "http://localhost:5050";
        document.Servers.Clear(); // Clear any existing servers
        document.Servers.Add(new OpenApiServer { Url = serverUrl });
        return Task.CompletedTask;
    }
}