namespace Overstay.Application.Features.Notifications.Requests;

public class NotificationRequest
{
    public bool EmailNotification { get; set; }
    public bool SmsNotification { get; set; }
    public bool PushNotification { get; set; }
    public bool NintyDaysNotification { get; set; }
    public bool ExpiredNotification { get; set; }
    public int DaysBefore { get; set; }
}
