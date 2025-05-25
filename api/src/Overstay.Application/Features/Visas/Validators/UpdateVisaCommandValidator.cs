using FluentValidation;
using Overstay.Application.Features.Visas.Commands;

namespace Overstay.Application.Features.Visas.Validators;

public class UpdateVisaCommandValidator : AbstractValidator<UpdateVisaCommand>
{
    public UpdateVisaCommandValidator()
    {
        RuleFor(x => x.Id).NotEmpty().WithMessage("Visa ID is required.");

        RuleFor(x => x.Item.VisaTypeId)
            .NotEmpty()
            .WithMessage("Visa type ID is required.")
            .When(x => x.Item.VisaTypeId != Guid.Empty);

        RuleFor(x => x.Item.ArrivalDate)
            .NotEmpty()
            .WithMessage("Arrival date is required.")
            .Must(date => date != DateTime.MinValue)
            .WithMessage(
                "Arrival date format is invalid. Please use one of these formats: yyyy-MM-dd, MM/dd/yyyy, dd-MM-yyyy, or ISO 8601."
            )
            .LessThanOrEqualTo(DateTime.UtcNow)
            .WithMessage("Arrival date must be less than or equal to today.")
            .When(x => x.Item.ArrivalDate != DateTime.MinValue && x.Item.ArrivalDate != default);

        RuleFor(x => x.Item.ExpireDate)
            .NotEmpty()
            .WithMessage("Expire date is required.")
            .Must(date => date != DateTime.MinValue)
            .WithMessage(
                "Expire date format is invalid. Please use one of these formats: yyyy-MM-dd, MM/dd/yyyy, dd-MM-yyyy, or ISO 8601."
            )
            .GreaterThanOrEqualTo(x => x.Item.ArrivalDate)
            .WithMessage("Expire date must be greater than or equal to arrival date.")
            .When(x => x.Item.ExpireDate != DateTime.MinValue && x.Item.ExpireDate != default);
    }
}
