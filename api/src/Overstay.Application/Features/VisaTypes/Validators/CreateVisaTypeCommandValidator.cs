using FluentValidation;
using Overstay.Application.Features.VisaTypes.Requests;

namespace Overstay.Application.Features.VisaTypes.Validators;

public class CreteVisaTypeCommandValidator : AbstractValidator<CreateVisaTypeRequest>
{
    public CreteVisaTypeCommandValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .WithMessage("Visa type name is required.")
            .MaximumLength(100)
            .WithMessage("Visa type name must not exceed 100 characters.");

        RuleFor(x => x.Description)
            .MaximumLength(500)
            .WithMessage("Description must not exceed 500 characters.");

        RuleFor(x => x.IsMultipleEntry)
            .NotNull()
            .WithMessage("IsMultipleEntry is required.");
    }
}