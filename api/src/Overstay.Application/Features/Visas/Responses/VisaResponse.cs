using Overstay.Application.Features.VisaTypes.Responses;

namespace Overstay.Application.Features.Visas.Responses;

public class VisaResponse
{
    public Guid Id { get; set; }
    public DateTime ArrivalDate { get; set; }
    public DateTime ExpireDate { get; set; }
    public bool IsActive { get; set; }
    public VisaTypeResponse VisaType { get; set; } = null!;
}
