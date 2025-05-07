using FluentValidation;
using Overstay.Application.Features.Visas.Commands;

namespace Overstay.Application.Features.Visas.Validators;

public class UpdateVisaCommandValidator : AbstractValidator<UpdateVisaCommand>
{
    public UpdateVisaCommandValidator()
    {
        RuleFor(x => x.Id).NotEmpty();

        RuleFor(x => x.Item.VisaTypeId)
            .NotEmpty()
            .WithMessage("Visa type ID is required.")
            .When(x => x.Item.VisaTypeId != Guid.Empty);
    
        RuleFor(x => x.Item.ArrivalDate)
            .NotEmpty()
            .WithMessage("Start date is required.")
            .LessThanOrEqualTo(DateTime.UtcNow)
            .WithMessage("Start date must be less than or equal to today.")
            .When(x => x.Item.ArrivalDate != DateTime.MinValue);
        
        RuleFor(x => x.Item.ExpireDate)
            .NotEmpty()
            .WithMessage("End date is required.")
            .GreaterThanOrEqualTo(x => x.Item.ArrivalDate)
            .When(x => x.Item.ExpireDate != DateTime.MinValue);
        
        
    }
}