using Overstay.Application.Services;
using Overstay.Domain.Constants;

namespace Overstay.Infrastructure.Services;

using System;

public class TimezoneProvider : ITimezoneProvider
{
    public DateTime GetCurrentTime(string timezoneId)
    {
        try
        {
            var timezone = TimeZoneInfo.FindSystemTimeZoneById(timezoneId);
            return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timezone);
        }
        catch (TimeZoneNotFoundException ex)
        {
            throw new ArgumentException($"Invalid timezone ID: {timezoneId}", ex);
        }
        catch (InvalidTimeZoneException ex)
        {
            throw new ArgumentException($"Invalid timezone data for ID: {timezoneId}", ex);
        }
    }

    public DateTime GetCurrentTimeInThailand()
    {
        return GetCurrentTime(Constant.ThailandTimezoneId);
    }
}
