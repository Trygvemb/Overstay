using Microsoft.AspNetCore.Identity;
using Overstay.Application.Commons.Constants;

namespace Overstay.Infrastructure.Data.Seeds;

public static class RolesSeed
{
    public static async Task EnsureRolesExistAsync(RoleManager<IdentityRole<Guid>> roleManager)
    {
        string[] roles = [RoleTypeConstants.Admin, RoleTypeConstants.User];

        foreach (var roleName in roles)
        {
            if (!await roleManager.RoleExistsAsync(roleName))
            {
                await roleManager.CreateAsync(new IdentityRole<Guid>(roleName));
            }
        }
    }
}
