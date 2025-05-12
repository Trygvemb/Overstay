namespace Overstay.Application.Commons.Models;

public class VisaEmailNotification
{
    public string Email { get; set; } = null!;
    public string UserName { get; set; } = null!;
    public int DaysBefore { get; set; }
    public bool ExpiredNotification { get; set; }
    public bool NintyDaysNotification { get; set; }
    public List<VisaNameAndDates> Visas { get; set; } = [];
}

public class VisaNameAndDates
{
    public string Name { get; set; } = null!;
    public DateTime ArrivalDate { get; set; }
    public DateTime ExpireDate { get; set; }
}
