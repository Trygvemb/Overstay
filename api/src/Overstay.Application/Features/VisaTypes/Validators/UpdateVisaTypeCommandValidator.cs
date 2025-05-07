using FluentValidation;
using Overstay.Application.Features.VisaTypes.Commands;
using Overstay.Application.Features.VisaTypes.Requests;

namespace Overstay.Application.Features.VisaTypes.Validators;

public class UpdateVisaTypeCommandValidator : AbstractValidator<UpdateVisaTypeCommand>
{
    public UpdateVisaTypeCommandValidator()
    {
        RuleFor(x => x.Id)
            .NotEmpty()
            .WithMessage("Visa type ID is required.");

        RuleFor(x => x.Item.Name)
            .NotEmpty()
            .WithMessage("Visa type name is required.")
            .MaximumLength(100)
            .WithMessage("Visa type name must not exceed 100 characters.");

        RuleFor(x => x.Item.Description)
            .MaximumLength(500)
            .WithMessage("Description must not exceed 500 characters.");

        RuleFor(x => x.Item.IsMultipleEntry)
            .NotNull()
            .WithMessage("IsMultipleEntry is required.");
    }
}