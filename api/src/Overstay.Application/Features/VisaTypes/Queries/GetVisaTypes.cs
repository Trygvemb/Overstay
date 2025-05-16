using Overstay.Application.Commons.Results;
using Overstay.Application.Features.VisaTypes.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.VisaTypes.Queries;

public sealed record GetVisaTypesQuery : IRequest<Result<List<VisaTypeResponse>>>;

public class GetVisaTypesCommandHandler(IVisaTypeService visaTypeService)
    : IRequestHandler<GetVisaTypesQuery, Result<List<VisaTypeResponse>>>
{
    public async Task<Result<List<VisaTypeResponse>>> Handle(
        GetVisaTypesQuery request,
        CancellationToken cancellationToken
    )
    {
        var visaTypes = await visaTypeService.GetAllAsync(cancellationToken);

        if (visaTypes.IsFailure)
            return Result.Failure<List<VisaTypeResponse>>(visaTypes.Error);

        var visaTypeResponse = visaTypes.Value.Adapt<List<VisaTypeResponse>>();
        return Result.Success(visaTypeResponse);
    }
}
