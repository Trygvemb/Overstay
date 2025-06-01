using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using Overstay.Application.Commons.Constants;
using Overstay.Infrastructure.Configurations;
using Overstay.Infrastructure.Data.DbContexts;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.Infrastructure.Data.Seeds;

public static class DatabaseInitializer
{
    public static async Task InitializeDatabaseAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var services = scope.ServiceProvider;
        var logger = services.GetRequiredService<ILogger<ApplicationDbContext>>();
        var context = services.GetRequiredService<ApplicationDbContext>();
        var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = services.GetRequiredService<RoleManager<IdentityRole<Guid>>>();

        try
        {
            logger.LogInformation("Checking database migrations...");
            if (!await context.Database.CanConnectAsync())
            {
                logger.LogInformation("Applying migrations...");
                await context.Database.MigrateAsync();
            }

            // These methods will check if data exists and seed if necessary
            await RolesSeed.EnsureRolesExistAsync(roleManager);
            await AdminSeed.EnsureAdminExistAsync(userManager, context);

            logger.LogInformation("Database initialization completed successfully");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while initializing the database");
        }
    }
}
