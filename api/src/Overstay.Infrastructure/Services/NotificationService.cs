using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;
using Overstay.Infrastructure.Data.DbContexts;

namespace Overstay.Infrastructure.Services;

public class NotificationService(ApplicationDbContext context, ILogger<NotificationService> logger)
    : INotificationService
{
    public async Task<Result<Guid>> CreateNotificationSettings(
        Notification notification,
        CancellationToken cancellationToken
    )
    {
        try
        {
            var userNotificationSettings = await context.Notifications.FirstOrDefaultAsync(
                n => n.UserId == notification.UserId,
                cancellationToken: cancellationToken
            );

            if (userNotificationSettings != null)
            {
                return Result.Failure<Guid>(NotificationErrors.NotificationsAlreadyExists);
            }

            await context.Notifications.AddAsync(notification, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success(notification.Id);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while creating notification settings.");
            return Result.Failure<Guid>(NotificationErrors.UnexpectedError);
        }
    }

    public async Task<Result> UpdateNotificationSettings(
        Notification notification,
        CancellationToken cancellationToken
    )
    {
        try
        {
            var existingNotificationResult = await GetNotificationSettings(
                notification.UserId,
                cancellationToken
            );

            if (existingNotificationResult.IsFailure)
            {
                return Result.Failure(NotificationErrors.NotFoundError);
            }

            var existingNotification = existingNotificationResult.Value;

            existingNotification.EmailNotification = notification.EmailNotification;
            existingNotification.SmsNotification = notification.SmsNotification;
            existingNotification.PushNotification = notification.PushNotification;
            existingNotification.NintyDaysNotification = notification.NintyDaysNotification;
            existingNotification.ExpiredNotification = notification.ExpiredNotification;
            existingNotification.DaysBefore = notification.DaysBefore;

            context.Notifications.Update(existingNotification);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while updating notification settings.");
            return Result.Failure(NotificationErrors.UnexpectedError);
        }
    }

    public async Task<Result<Notification>> GetNotificationSettings(
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        try
        {
            var notification = await context.Notifications.FirstOrDefaultAsync(
                n => n.UserId == userId,
                cancellationToken: cancellationToken
            );

            return notification is null
                ? Result.Failure<Notification>(NotificationErrors.NotFoundError)
                : Result.Success(notification);
        }
        catch (Exception ex)
        {
            logger.LogError(
                ex,
                "An error occurred while retrieving notification settings for user ID {UserId}",
                userId
            );
            return Result.Failure<Notification>(NotificationErrors.UnexpectedError);
        }
    }
}
