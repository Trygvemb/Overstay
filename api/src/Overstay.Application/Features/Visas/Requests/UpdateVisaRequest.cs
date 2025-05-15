using System.Text.Json.Serialization;
using Overstay.Application.Commons.Behaviors;

namespace Overstay.Application.Features.Visas.Requests;

public class UpdateVisaRequest
{
    [JsonConverter(typeof(DateTimeBehavior))]
    public DateTime ArrivalDate { get; set; }

    [JsonConverter(typeof(DateTimeBehavior))]
    public DateTime ExpireDate { get; set; }
    public Guid VisaTypeId { get; set; }
}
