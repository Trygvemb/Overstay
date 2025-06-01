using System.Text.Json.Serialization;
using Overstay.API.Commons;
using Overstay.Application.Commons.Helpers;
using Overstay.Application.Extensions;
using Overstay.Infrastructure.Data.Seeds;
using Overstay.Infrastructure.Extensions;
using Overstay.Infrastructure.Services;
using Overstay.Infrastructure.Services.BackgroundServices;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder
    .Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
        options.JsonSerializerOptions.Converters.Add(new ResultJsonConverter());
        options.JsonSerializerOptions.Converters.Add(new ResultJsonConverterFactory());
    });

builder.Services.AddOpenApi(
    "v1",
    options =>
    {
        options.AddDocumentTransformer<BearerSecuritySchemeTransformer>();
        options.AddDocumentTransformer(
            new OpenApiServerTransformer(builder.Configuration, builder.Environment)
        );
    }
);

builder.Services.AddApplicationLayer();
builder.Services.AddInfrastructureServices(builder.Configuration);

builder.Services.AddDbContext(builder.Configuration);
builder.Services.AddFluentEmail(builder.Configuration);
builder.Services.AddIdentity(builder.Configuration);
builder.Services.AddAuthentication(builder.Configuration);
builder.Services.AddAuthorizationPolicies();

builder.Services.AddHostedService<VisaReminderBackgroundService>();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy
            .WithOrigins(
                "https://localhost:7139",
                "http://localhost:5093",
                "http://localhost:8080", // Docker frontend URL
                "http://localhost:5050" // Docker API URL
            )
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials(); // Essential for cookies to work
    });
});

builder.Services.ConfigureExternalCookie(options =>
{
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Lax; // Lax is needed for OAuth redirects
    options.ExpireTimeSpan = TimeSpan.FromMinutes(5);
});

builder
    .Logging.ClearProviders()
    .AddConsole()
    .AddDebug()
    .SetMinimumLevel(LogLevel.Information)
    .AddFilter("Microsoft.AspNetCore.Authorization", LogLevel.Debug)
    .AddFilter("Microsoft.AspNetCore.Authentication", LogLevel.Debug)
    .AddFilter("Microsoft.AspNetCore.Authentication.Google", LogLevel.Debug)
    .AddFilter("Microsoft.AspNetCore.Authentication.Cookies", LogLevel.Debug);

builder
    .Configuration.SetBasePath(builder.Environment.ContentRootPath)
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile(
        $"appsettings.{builder.Environment.EnvironmentName}.json",
        optional: true,
        reloadOnChange: true
    )
    .AddEnvironmentVariables();

var app = builder.Build();

app.MapOpenApi();
app.MapScalarApiReference();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();

    // Makes sure the database is initialized in development with admin user
    await DatabaseInitializer.InitializeDatabaseAsync(app.Services);
}
else
{
    app.UseHttpsRedirection();
}

app.UseRouting();
app.UseCors();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
