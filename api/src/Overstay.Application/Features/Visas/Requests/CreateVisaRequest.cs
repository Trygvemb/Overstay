using System.Text.Json.Serialization;
using Overstay.Application.Commons.Behaviors;

namespace Overstay.Application.Features.Visas.Requests;

public class CreateVisaRequest
{
    [JsonConverter(typeof(DateToDateTimeConverter))]
    public DateTime ArrivalDate { get; set; }
    
    [JsonConverter(typeof(DateToDateTimeConverter))]
    public DateTime ExpireDate { get; set; }
    public Guid VisaTypeId { get; set; }
}
