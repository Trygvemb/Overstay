using Overstay.Domain.Constants;

namespace Overstay.Domain.Entities;

/// <summary>
/// Represents a visa entity within the domain.
/// A Visa is associated with a user and a specific visa type
/// </summary>
public class Visa : Entity
{
    public DateTime ArrivalDate { get; }
    public DateTime ExpireDate { get; private set; }
    public bool IsActive { get; private set; } = true;

    public Guid VisaTypeId { get; set; }
    public Guid UserId { get; set; }

    public VisaType VisaType { get; } = null!;
    public User User { get; set; } = null!;

    protected Visa()
    {
        SetIsActive();
    }

    public Visa(DateTime? arrivalDate, DateTime? expireDate)
    {
        ArrivalDate = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            arrivalDate ?? DateTime.Now,
            Constant.ThailandTimezoneId
        );
        ExpireDate = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            expireDate ?? DateTime.Now,
            Constant.ThailandTimezoneId
        );

        SetIsActive();
    }

    public bool SetIsActive(bool? isActive = null)
    {
        if (isActive.HasValue)
        {
            IsActive = isActive.Value;
        }
        else
        {
            IsActive =
                ExpireDate
                >= TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
                    DateTime.Now,
                    Constant.ThailandTimezoneId
                );
        }

        return IsActive;
    }
}
