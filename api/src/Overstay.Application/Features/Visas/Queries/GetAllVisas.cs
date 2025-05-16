using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Visas.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Visas.Queries;

public sealed record GetAllVisasQuery(Guid UserId) : IRequest<Result<List<VisaResponse>>>;

public class GetAllVisasCommandHandler(IVisaService visaService)
    : IRequestHandler<GetAllVisasQuery, Result<List<VisaResponse>>>
{
    public async Task<Result<List<VisaResponse>>> Handle(
        GetAllVisasQuery request,
        CancellationToken cancellationToken
    )
    {
        var visas = await visaService.GetAllAsync(request.UserId, cancellationToken);

        if (visas.IsFailure)
            return Result.Failure<List<VisaResponse>>(visas.Error);

        var visaResponses = visas.Value.Adapt<List<VisaResponse>>();
        return Result.Success(visaResponses);
    }
}
