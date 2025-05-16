using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Visas.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Visas.Queries;

public sealed record GetVisaQuery(Guid UserId) : IRequest<Result<VisaResponse>>;

public class GetVisaCommandHandler(IVisaService visaService)
    : IRequestHandler<GetVisaQuery, Result<VisaResponse>>
{
    public async Task<Result<VisaResponse>> Handle(
        GetVisaQuery request,
        CancellationToken cancellationToken
    )
    {
        var visa = await visaService.GetActiveVisaAsync(request.UserId, cancellationToken);

        if (visa.IsFailure)
            return Result.Failure<VisaResponse>(visa.Error);

        var visaResponse = visa.Value.Adapt<VisaResponse>();
        return Result.Success(visaResponse);
    }
}
