using FluentValidation;
using Overstay.Application.Features.Users.Commands;

namespace Overstay.Application.Features.Users.Validators;

public class CreateUserCommandValidator : AbstractValidator<CreateUserCommand>
{
    public CreateUserCommandValidator()
    {
        RuleFor(user => user.Item.Email).NotNull().EmailAddress();
        RuleFor(user => user.Item.UserName).NotNull();
        RuleFor(user => user.Item.CountryId).NotNull();

        RuleFor(user => user.Item.Password)
            .NotNull()
            .MinimumLength(8)
            .Matches("[A-Z]")
            .WithMessage("Password must contain at least one uppercase letter.")
            .Matches("[a-z]")
            .WithMessage("Password must contain at least one lowercase letter.")
            .Matches("[0-9]")
            .WithMessage("Password must contain at least one digit.")
            .Matches("[^a-zA-Z0-9]")
            .WithMessage("Password must contain at least one non-alphanumeric character.");
    }
}
