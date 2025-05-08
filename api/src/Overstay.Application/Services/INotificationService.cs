using Overstay.Application.Commons.Results;

namespace Overstay.Application.Services;

public interface INotificationService
{
    Task<Result<Guid>> CreateNotificationSettings(
        Notification notification,
        CancellationToken cancellationToken
    );
    Task<Result> UpdateNotificationSettings(
        Notification notification,
        CancellationToken cancellationToken
    );
    Task<Result<Notification>> GetNotificationSettings(
        Guid userId,
        CancellationToken cancellationToken
    );
}
