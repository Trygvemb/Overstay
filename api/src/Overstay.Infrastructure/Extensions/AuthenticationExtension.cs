using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace Overstay.Infrastructure.Extensions;

public static class AuthenticationExtension
{
    public static void AddAuthentication(
        this IServiceCollection services,
        IConfiguration configuration
    )
    {
        services
            .AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultSignInScheme = IdentityConstants.ExternalScheme; // CRITICAL: This is required for OAuth flows
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
                options.ClientId = configuration["Authentication:Google:ClientId"]!;
                options.ClientSecret = configuration["Authentication:Google:ClientSecret"]!;
                options.CallbackPath = "/signin-google";
                options.SaveTokens = true; // Important for GetExternalLoginInfoAsync to work
                options.Events.OnCreatingTicket = ctx =>
                {
                    var identity = (ClaimsIdentity)ctx.Principal.Identity;
                    var email = ctx.User.GetProperty("email").GetString();
                    var name = ctx.User.GetProperty("name").GetString();
                    identity!.AddClaim(new Claim(ClaimTypes.Email, email!));
                    identity.AddClaim(new Claim(ClaimTypes.Name, name!));
                    return Task.CompletedTask;
                };
            });
    }
}
