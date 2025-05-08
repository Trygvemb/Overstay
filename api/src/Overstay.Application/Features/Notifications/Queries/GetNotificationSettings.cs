using MapsterMapper;
using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Notifications.Responses;
using Overstay.Application.Services;

namespace Overstay.Application.Features.Notifications.Queries;

public sealed record GetNotificationSettingsQuery(Guid UserId)
    : IRequest<Result<NotificationSettingsResponse>>;

public class GetNotificationSettingsCommandHandler(
    INotificationService notificationService,
    IMapper mapper
) : IRequestHandler<GetNotificationSettingsQuery, Result<NotificationSettingsResponse>>
{
    public async Task<Result<NotificationSettingsResponse>> Handle(
        GetNotificationSettingsQuery request,
        CancellationToken cancellationToken
    )
    {
        var result = await notificationService.GetNotificationSettings(
            request.UserId,
            cancellationToken
        );

        if (result.IsSuccess)
        {
            var notificationSettings = result.Value;
            var response = mapper.Map<NotificationSettingsResponse>(notificationSettings);
            return Result.Success(response);
        }
        return Result.Failure<NotificationSettingsResponse>(result.Error);
    }
}
