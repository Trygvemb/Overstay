namespace Overstay.Application.Responses;

public class VisaEmailNotificationsResponse
{
    public string Email { get; set; } = null!;
    public string UserName { get; set; } = null!;
    public int DaysBefore { get; set; }
    public bool ExpiredNotification { get; set; }
    public bool NintyDaysNotification { get; set; }
    public List<VisaNotificationResponse> Visas { get; set; } = [];
}

public class VisaNotificationResponse
{
    public string Name { get; set; } = null!;
    public DateTime ArrivalDate { get; set; }
    public DateTime ExpireDate { get; set; }
}
