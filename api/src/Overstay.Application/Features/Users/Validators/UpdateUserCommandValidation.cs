using FluentValidation;
using Overstay.Application.Features.Users.Commands;

namespace Overstay.Application.Features.Users.Validators;

public class UpdateUserCommandValidation : AbstractValidator<UpdateUserCommand>
{
    public UpdateUserCommandValidation()
    {
        RuleFor(user => user.Id).NotEmpty();

        // RuleFor(user => user.Item.Password).Empty()
        //     .MinimumLength(8)
        //     .Matches("[A-Z]")
        //     .WithMessage("Password must contain at least one uppercase letter.")
        //     .Matches("[a-z]")
        //     .WithMessage("Password must contain at least one lowercase letter.")
        //     .Matches("[0-9]")
        //     .WithMessage("Password must contain at least one digit.")
        //     .Matches("[^a-zA-Z0-9]")
        //     .WithMessage("Password must contain at least one non-alphanumeric character.");
    }
}