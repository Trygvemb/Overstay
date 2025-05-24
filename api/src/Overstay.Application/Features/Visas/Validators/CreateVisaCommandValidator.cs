using FluentValidation;
using Overstay.Application.Features.Visas.Commands;

namespace Overstay.Application.Features.Visas.Validators;

public class CreateVisaCommandValidator : AbstractValidator<CreateVisaCommand>
{
    public CreateVisaCommandValidator()
    {
        RuleFor(x => x.Item.VisaTypeId).NotNull().WithMessage("Visa type ID is required.");

        RuleFor(x => x.Item.ArrivalDate)
            .NotNull()
            .WithMessage("Arrival date is required.")
            .Must(date => date != DateTime.MinValue)
            .WithMessage(
                "Arrival date format is invalid. Please use one of these formats: yyyy-MM-dd, MM/dd/yyyy, dd-MM-yyyy, or ISO 8601."
            )
            .LessThanOrEqualTo(DateTime.UtcNow)
            .WithMessage("Arrival date must be less than or equal to today.")
            .When(x => x.Item.ArrivalDate != null && x.Item.ArrivalDate != DateTime.MinValue);

        RuleFor(x => x.Item.ExpireDate)
            .NotNull()
            .WithMessage("Expire date is required.")
            .Must(date => date != DateTime.MinValue)
            .WithMessage(
                "Expire date format is invalid. Please use one of these formats: yyyy-MM-dd, MM/dd/yyyy, dd-MM-yyyy, or ISO 8601."
            )
            .GreaterThanOrEqualTo(x => x.Item.ArrivalDate)
            .WithMessage("Expire date must be greater than or equal to arrival date.")
            .When(x => x.Item.ExpireDate != null && x.Item.ExpireDate != DateTime.MinValue);
    }
}
