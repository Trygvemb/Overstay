using Overstay.Domain.Entities;
using Shouldly;

namespace Overstay.UnitTest.Domain.Entities;

public class VisaTests
{
    private readonly VisaType _tesVisaType = new VisaType("test name", "test description", true);
    
    [Fact]
    public void IsExpired_ShouldReturnTrue_WhenExpired()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime - TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime, _tesVisaType);
        
        visa.IsExpired().ShouldBe(true);
    }
    
    [Fact]
    public void IsExpired_ShouldReturnFalse_WhenNotExpired()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime + TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime, _tesVisaType);
        
        visa.IsExpired().ShouldBe(false);
    }
    
    [Fact]
    public void Times_ShouldBeInThailandTimeZone_WhenInstantiated()
    {
        var arrivalDateTime = DateTime.UtcNow;
        var expiredDateTime = arrivalDateTime + TimeSpan.FromHours(1);
        var visa = new Visa(arrivalDateTime, expiredDateTime, _tesVisaType);

        var arrivalThailandTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(arrivalDateTime, "Asia/Bangkok");
        var expireThailandTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(expiredDateTime, "Asia/Bangkok");
        
        visa.ArrivalDate.ShouldBe(arrivalThailandTime);
        visa.ExpireDate.ShouldBe(expireThailandTime);
    }
}