using Overstay.Application.Commons.Results;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Users.Commands;

public sealed record ExternalLoginCommand(string Provider, string? ReturnUrl = null) : IRequest<Result<string>>;

public class ExternalLoginCommandHandler(IUserService userService)
    : IRequestHandler<ExternalLoginCommand, Result<string>>
{
    public async Task<Result<string>> Handle(ExternalLoginCommand request, CancellationToken cancellationToken)
    {
        return await userService.ValidateExternalAuthProvider(
            request.Provider,
            request.ReturnUrl!);
    }
}