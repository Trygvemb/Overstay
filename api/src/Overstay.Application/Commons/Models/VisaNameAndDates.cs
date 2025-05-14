namespace Overstay.Application.Commons.Models;

public class VisaNameAndDates
{
    public string Name { get; set; } = null!;
    public DateTime ArrivalDate { get; set; }
    public DateTime ExpireDate { get; set; }
}
