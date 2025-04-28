using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Users.Requests;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Users.Commands;

public sealed record ExternalLoginCommand(ExternalLoginRequest Item) : IRequest<Result<string>>;

public class ExternalLoginCommandHandler(IUserService userService)
    : IRequestHandler<ExternalLoginCommand, Result<string>>
{
    public async Task<Result<string>> Handle(ExternalLoginCommand request, CancellationToken cancellationToken)
    {
        return userService.ConfigureExternalAuthenticationProperties(
            request.Item.Provider,
            request.Item.ReturnUrl);
    }
}