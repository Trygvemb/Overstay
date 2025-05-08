namespace Overstay.Application.Features.Notifications.Responses;

public sealed record NotificationSettingsResponse(
    Guid Id,
    bool EmailNotification,
    bool SmsNotification,
    bool PushNotification,
    bool NintyDaysNotification,
    bool ExpiredNotification,
    int DaysBefore,
    Guid UserId
);
