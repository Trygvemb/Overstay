using Microsoft.AspNetCore.Identity;

namespace Overstay.Infrastructure.Data.Identities;

public class ApplicationUser : IdentityUser
{
    public Guid DomainUserId { get; init; }
    public User DomainUser { get; init; } = null!;
}
