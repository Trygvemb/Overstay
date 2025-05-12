using Overstay.Application.Commons.Models;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Users.Commands;

public sealed record ExternalLoginCallbackCommand(string ReturnUrl)
    : IRequest<Result<ExternalAuth>>;

public class ExternalLoginCallbackCommandHandler(IUserService userService)
    : IRequestHandler<ExternalLoginCallbackCommand, Result<ExternalAuth>>
{
    public async Task<Result<ExternalAuth>> Handle(
        ExternalLoginCallbackCommand request,
        CancellationToken cancellationToken
    )
    {
        return await userService.ProcessExternalLoginCallbackAsync(request.ReturnUrl);
    }
}
