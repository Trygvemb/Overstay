using Overstay.Domain.Entities;
using Shouldly;

namespace Overstay.UnitTest.Domain.Entities;

public class VisaTests
{
    [Fact]
    public void IsActive_ShouldBeFalse_WhenExpired()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime - TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime);

        visa.IsActive.ShouldBe(false);
    }

    [Fact]
    public void IsActive_ShouldBeTrue_WhenNotExpired()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime + TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime);

        visa.IsActive.ShouldBe(true);
    }

    [Fact]
    public void SetIsActive_ShouldReturnFalse_WhenCalledWithFalse()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime + TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime);

        visa.SetIsActive(false).ShouldBe(false);
        visa.IsActive.ShouldBe(false);
    }

    [Fact]
    public void Times_ShouldBeInThailandTimeZone_WhenInstantiated()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime + TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime);

        var arrivalThailandTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            arrivalDateTime,
            "Asia/Bangkok"
        );
        var expireThailandTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            expiredDateTime,
            "Asia/Bangkok"
        );

        visa.ArrivalDate.ShouldBe(arrivalThailandTime);
        visa.ExpireDate.ShouldBe(expireThailandTime);
    }
}
