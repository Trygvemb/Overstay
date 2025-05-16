namespace Overstay.Application.Commons.Helpers;

public interface ITimezoneProvider
{
    DateTime GetCurrentTime(string timezoneId);
    DateTime GetCurrentTimeInThailand();
}
