using MapsterMapper;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Notifications.Commands;

public sealed record CreateNotificationSettingsCommand(
    bool EmailNotification,
    bool SmsNotification,
    bool PushNotification,
    bool NintyDaysNotification,
    bool ExpiredNotification,
    int DaysBefore,
    Guid UserId
) : IRequest<Result<Guid>>;

public class CreateNotificationSettingsCommandHandler(
    INotificationService notificationService,
    IMapper mapper
) : IRequestHandler<CreateNotificationSettingsCommand, Result<Guid>>
{
    public async Task<Result<Guid>> Handle(
        CreateNotificationSettingsCommand request,
        CancellationToken cancellationToken
    )
    {
        var notification = mapper.Map<Notification>(request);
        return await notificationService.CreateNotificationSettings(
            notification,
            cancellationToken
        );
    }
}
