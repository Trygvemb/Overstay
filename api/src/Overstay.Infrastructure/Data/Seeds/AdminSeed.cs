using Microsoft.AspNetCore.Identity;
using Overstay.Application.Commons.Constants;
using Overstay.Infrastructure.Data.DbContexts;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.Infrastructure.Data.Seeds;

public static class AdminSeed
{
    public static async Task EnsureAdminExistAsync(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext context
    )
    {
        var admin = await userManager.FindByEmailAsync("admin@example.com");

        if (admin is null)
        {
            var ukCountryId = new Guid("00000000-0000-0000-0000-000000000183");
            admin = new ApplicationUser
            {
                UserName = "admin@example.com",
                Email = "admin@example.com",
                EmailConfirmed = true,
            };

            await userManager.CreateAsync(admin, "Admin123!");
            await userManager.AddToRolesAsync(
                admin,
                [RoleTypeConstants.Admin, RoleTypeConstants.User]
            );

            var user = new User(ukCountryId) { Id = admin.Id };

            await context.Users.AddAsync(user);
            await context.SaveChangesAsync();
        }
    }
}
