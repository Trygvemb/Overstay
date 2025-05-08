using MapsterMapper;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Notifications.Commands;

public sealed record UpdateNotificationSettingsCommand(
    bool EmailNotification,
    bool SmsNotification,
    bool PushNotification,
    bool NintyDaysNotification,
    bool ExpiredNotification,
    int DaysBefore,
    Guid UserId
) : IRequest<Result>;

public class UpdateNotificationSettingsCommandHandler(
    INotificationService notificationService,
    IMapper mapper
) : IRequestHandler<UpdateNotificationSettingsCommand, Result>
{
    public Task<Result> Handle(
        UpdateNotificationSettingsCommand request,
        CancellationToken cancellationToken
    )
    {
        var notification = mapper.Map<Notification>(request);
        return notificationService.UpdateNotificationSettings(notification, cancellationToken);
    }
}
