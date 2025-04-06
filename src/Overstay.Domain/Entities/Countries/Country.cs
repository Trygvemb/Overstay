using Overstay.Domain.Entities.Users;

namespace Overstay.Domain.Entities.Countries;

/// <summary>
/// Represents a country entity that includes information about its name,
/// ISO code, and the associated users.
/// </summary>
public class Country : Entity
{
    #region Fields, ForeignKeys, Navigation Properties
    public string Name { get; init; } = string.Empty;
    public string IsoCode { get; init; } = string.Empty;
    public virtual ICollection<User> Users { get; set; } = new HashSet<User>();
    #endregion
}
