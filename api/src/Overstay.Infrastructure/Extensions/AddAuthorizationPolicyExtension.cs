using Microsoft.Extensions.DependencyInjection;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.Infrastructure.Extensions;

public static class AddAuthorizationPolicyExtension
{
    public static void AddAuthorizationPolicies(this IServiceCollection services)
    {
        services
            .AddAuthorizationBuilder()
            .AddPolicy(
                "SameUserOrAdmin",
                policy => policy.Requirements.Add(new SameUserOrAdminRequirement())
            );
    }
}
