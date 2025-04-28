using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Users.Requests;
using Overstay.Application.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Users.Commands;

public sealed record ExternalLoginCallbackCommand(ExternalLoginCallbackRequest Item) : IRequest<Result<ExternalAuthResponse>>;

public class ExternalLoginCallbackCommandHandler(IUserService userService) : IRequestHandler<ExternalLoginCallbackCommand, Result<ExternalAuthResponse>>
{
    public async Task<Result<ExternalAuthResponse>> Handle(ExternalLoginCallbackCommand request, CancellationToken cancellationToken)
    {
        return await userService.ProcessExternalLoginCallbackAsync(
            request.Item.ReturnUrl,
            request.Item.RemoteError);
    }
}