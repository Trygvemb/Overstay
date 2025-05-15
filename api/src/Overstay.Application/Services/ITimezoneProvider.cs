namespace Overstay.Application.Services;

public interface ITimezoneProvider
{
    DateTime GetCurrentTime(string timezoneId);
    DateTime GetCurrentTimeInThailand();
}
