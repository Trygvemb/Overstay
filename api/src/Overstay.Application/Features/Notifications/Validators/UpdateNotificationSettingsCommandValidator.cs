using FluentValidation;
using Overstay.Application.Features.Notifications.Commands;

namespace Overstay.Application.Features.Notifications.Validators;

public class UpdateNotificationSettingsCommandValidator
    : AbstractValidator<UpdateNotificationSettingsCommand>
{
    public UpdateNotificationSettingsCommandValidator()
    {
        RuleFor(x => x.DaysBefore)
            .Must(days => days > 0 && days <= 30)
            .WithMessage(
                "DaysBefore must be a positive number and no more than 30 days in advance."
            );
    }
}
