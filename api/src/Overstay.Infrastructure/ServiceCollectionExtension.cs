using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.OAuth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Overstay.Application.Services;
using Overstay.Infrastructure.Configurations;
using Overstay.Infrastructure.Data.DbContexts;
using Overstay.Infrastructure.Data.Identities;
using Overstay.Infrastructure.Services;

namespace Overstay.Infrastructure;

public static class ServiceCollectionExtension
{
    public static IServiceCollection AddInfrastructureLayer(
        this IServiceCollection services,
        IConfiguration configuration
    )
    {
        var dbOptions = DatabaseOptions.Load(configuration);

        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(
                dbOptions.ConnectionString,
                mysqlOptions =>
                {
                    mysqlOptions.MigrationsAssembly("Overstay.Infrastructure");
                    mysqlOptions.EnableRetryOnFailure();
                    mysqlOptions.CommandTimeout(60);
                }
            )
        );

        services
            .AddIdentity<ApplicationUser, IdentityRole<Guid>>(options =>
            {
                options.Password.RequiredLength = 8;
                options.Password.RequireDigit = true;
                options.Password.RequireUppercase = true;
                options.Password.RequireNonAlphanumeric = true;
                options.Password.RequireLowercase = true;
                options.User.RequireUniqueEmail = true;
            })
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();
        
        // Add session support for tracking OAuth state
        services.AddDistributedMemoryCache();
        services.AddSession(options =>
        {
            options.IdleTimeout = TimeSpan.FromMinutes(20);
            options.Cookie.HttpOnly = true;
            options.Cookie.IsEssential = true; // Important for GDPR
            options.Cookie.SameSite = SameSiteMode.Lax; // Must match the cookie policy
            options.Cookie.SecurePolicy = CookieSecurePolicy.None; // For development
        });


        // Configure cookie policy
        services.Configure<CookiePolicyOptions>(options =>
        {
            options.CheckConsentNeeded = context => false;
            options.MinimumSameSitePolicy = SameSiteMode.Lax;
            options.Secure = CookieSecurePolicy.None;

            // Add this debugging
            options.OnAppendCookie = cookieContext => 
            {
                Console.WriteLine($"Cookie appended: {cookieContext.CookieName}");
            };
            options.OnDeleteCookie = cookieContext => 
            {
                Console.WriteLine($"Cookie deleted: {cookieContext.CookieName}");
            };

        });


        services
            .AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultSignInScheme = IdentityConstants.ExternalScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = configuration["JwtSettings:Issuer"],
                    ValidAudience = configuration["JwtSettings:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(
                            configuration["JwtSettings:SecretKey"]
                            ?? throw new InvalidOperationException()
                        )
                    ),
                };

                options.Events = new JwtBearerEvents
                {
                    OnAuthenticationFailed = context =>
                    {
                        Console.WriteLine($"Authentication failed: {context.Exception.Message}");
                        return Task.CompletedTask;
                    },
                    OnMessageReceived = context =>
                    {
                        Console.WriteLine(
                            $"Token received: {context.Token?[..Math.Min(20, context.Token?.Length ?? 0)]}..."
                        );
                        return Task.CompletedTask;
                    },
                    OnTokenValidated = context =>
                    {
                        Console.WriteLine(
                            $"Token validated for: {context.Principal?.Identity?.Name}"
                        );
                        return Task.CompletedTask;
                    },
                };
            })
            .AddGoogle(options =>
            {
                var googleAuthSection = configuration.GetSection("Authentication:Google");
                options.ClientId = googleAuthSection["ClientId"] ??
                                   throw new InvalidOperationException("Google Client Id is missing");
                options.ClientSecret = googleAuthSection["ClientSecret"] ??
                                       throw new InvalidOperationException("Google Client Secret is missing");
                options.CallbackPath = "/api/Auth/external-login-callback";

                // These settings are critical for cookies to work properly
                options.CorrelationCookie.SecurePolicy = CookieSecurePolicy.None; // For dev
                options.CorrelationCookie.SameSite = SameSiteMode.Lax;
                options.CorrelationCookie.HttpOnly = true;
                options.CorrelationCookie.IsEssential = true;
    
                options.SaveTokens = true;
            });

        services
            .AddAuthorizationBuilder()
            .AddPolicy(
                "SameUserOrAdmin",
                policy => policy.Requirements.Add(new SameUserOrAdminRequirement())
            );
        services.AddScoped<IAuthorizationHandler, SameUserOrAdminHandler>();
        services.AddScoped<IVisaTypeService, VisaTypeService>();
        services.AddScoped<IVisaService, VisaService>();
        services.AddScoped<ITokenService, TokenService>();
        services.AddScoped<IUserService, UserService>();

        return services;
    }
}
