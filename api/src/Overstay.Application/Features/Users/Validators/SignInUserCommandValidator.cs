using FluentValidation;
using Overstay.Application.Features.Users.Commands;

namespace Overstay.Application.Features.Users.Validators;

public class SignInUserCommandValidator : AbstractValidator<SigInUserCommand>
{
    public SignInUserCommandValidator()
    {
        RuleFor(x => x.Item.Password)
            .NotNull();
        
        RuleFor(x => x.Item.UserName)
            .NotNull();
    }
}