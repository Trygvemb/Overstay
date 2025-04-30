using System.Reflection;
using System.Reflection.Metadata;
using System.Text.Json.Serialization;
using FluentValidation;
using Overstay.API.Commons;
using Overstay.Application;
using Overstay.Application.Commons.Behaviors;
using Overstay.Application.Commons.JsonConverters;
using Overstay.Infrastructure;
using Overstay.Infrastructure.Data;
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

builder.Services.AddInfrastructureLayer(builder.Configuration).AddApplicationLayer();

// Configure CORS correctly
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy
            .WithOrigins("http://localhost:5093") // Your domain
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials(); // Essential for cookies to work
    });
});

builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(20);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder
    .Logging.ClearProviders()
    .AddConsole()
    .AddDebug()
    .SetMinimumLevel(LogLevel.Information)
    .AddFilter("Microsoft.AspNetCore.Authorization", LogLevel.Debug);

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

    // Initialize a database with seed data
    await DatabaseInitializer.InitializeDatabaseAsync(app.Services);
}
else
{
    app.UseHttpsRedirection();
}

app.UseRouting();
app.UseSession();
app.UseCookiePolicy();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
