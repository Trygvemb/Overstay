using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Overstay.Application.Services;
using Overstay.Infrastructure.Configurations;
using Overstay.Infrastructure.Data.DbContexts;
using Overstay.Infrastructure.Data.Identities;
using Overstay.Infrastructure.Services;

namespace Overstay.Infrastructure.Extensions;

public static class ServiceCollectionExtension
{
    public static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services,
        IConfiguration configuration
    )
    {
        services.AddScoped<IAuthorizationHandler, SameUserOrAdminHandler>();
        services.AddScoped<IVisaTypeService, VisaTypeService>();
        services.AddScoped<IVisaService, VisaService>();
        services.AddScoped<ITokenService, TokenService>();
        services.AddScoped<IUserService, UserService>();
        services.AddScoped<INotificationService, NotificationService>();
        services.AddScoped<IEmailService, EmailService>();

        return services;
    }
}
