using FluentValidation;
using Overstay.Application.Features.Visas.Commands;

namespace Overstay.Application.Features.Visas.Validators;

public class CreateVisaCommandValidator : AbstractValidator<CreateVisaCommand>
{
    public CreateVisaCommandValidator()
    {
        RuleFor(x => x.Item.VisaTypeId)
            .NotEmpty()
            .WithMessage("Visa type ID is required.");

        RuleFor(x => x.Item.ArrivalDate)
            .NotEmpty()
            .WithMessage("Start date is required.")
            .LessThanOrEqualTo(DateTime.UtcNow)
            .WithMessage("Start date must be less than or equal to today.");

        RuleFor(x => x.Item.ExpireDate)
            .NotEmpty()
            .WithMessage("End date is required.")
            .GreaterThanOrEqualTo(x => x.Item.ArrivalDate);
    }
}