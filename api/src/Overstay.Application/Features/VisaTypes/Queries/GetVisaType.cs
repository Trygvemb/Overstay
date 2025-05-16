using Overstay.Application.Commons.Results;
using Overstay.Application.Features.VisaTypes.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.VisaTypes.Queries;

public sealed record GetVisaTypeQuery(Guid Id) : IRequest<Result<VisaTypeResponse>>;

public class GetVisaTypeCommandHandler(IVisaTypeService visaTypeService)
    : IRequestHandler<GetVisaTypeQuery, Result<VisaTypeResponse>>
{
    public async Task<Result<VisaTypeResponse>> Handle(
        GetVisaTypeQuery request,
        CancellationToken cancellationToken
    )
    {
        var visaType = await visaTypeService.GetByIdAsync(request.Id, cancellationToken);

        if (visaType.IsFailure)
            return Result.Failure<VisaTypeResponse>(visaType.Error);

        var visaTypeResponse = visaType.Value.Adapt<VisaTypeResponse>();
        return Result.Success(visaTypeResponse);
    }
}
