using Overstay.Domain.Constants;
using Overstay.Domain.Entities.Users;

namespace Overstay.Domain.Entities.Visas;

/// <summary>
/// Represents a visa entity within the domain.
/// A Visa is associated with a user and a specific visa type, and contains details about
/// the arrival date and expiration date of the visa.
/// </summary>
public class Visa : Entity
{
    #region Fields, ForeignKeys, Navigation Properties
    public DateTime ArrivalDate { get; }
    public DateTime ExpireDate { get; private set; }

    public Guid VisaTypeId { get; set; }
    public Guid UserId { get; set; }

    public virtual VisaType VisaType { get; } = null!;
    public virtual User User { get; set; } = null!;
    #endregion

    public Visa() { }

    public Visa(DateTime? arrivalDate, DateTime? expireDate, VisaType type)
    {
        VisaType = type ?? throw new ArgumentNullException(nameof(type), "VisaType is required.");
        ArrivalDate = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            arrivalDate ?? DateTime.Now,
            Constant.ThailandTimezoneId
        );
        ExpireDate = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            expireDate ?? GetExpirationDateFromType(),
            Constant.ThailandTimezoneId
        );
    }

    public bool IsExpired()
    {
        return ExpireDate
            < TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.Now, Constant.ThailandTimezoneId);
    }

    public void SetExpireDateFromVisaType()
    {
        ExpireDate = ArrivalDate.Add(TimeSpan.FromDays(VisaType.DurationInDays));
    }

    public DateTime GetExpirationDateFromType()
    {
        return ArrivalDate.Add(TimeSpan.FromDays(VisaType.DurationInDays));
    }
}
