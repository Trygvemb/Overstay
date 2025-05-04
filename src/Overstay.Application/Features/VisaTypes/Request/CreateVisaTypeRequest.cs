namespace Overstay.Application.Features.VisaTypes.Request;

public class CreateVisaTypeRequest
{
    public string? Name { get; set; }
    public string? Description { get; set; }
    public int DurationInDays { get; set; }
    public bool IsMultipleEntry { get; set; }
}
