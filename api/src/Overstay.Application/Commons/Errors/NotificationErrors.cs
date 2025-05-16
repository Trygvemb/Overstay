using Overstay.Application.Commons.Constants;

namespace Overstay.Application.Commons.Errors;

public sealed record NotificationErrors
{
    public static Error NotificationsAlreadyExists =>
        new Error(ErrorTypeConstants.Conflict, "User can only have one notification settings.");

    public static Error UnexpectedError =>
        new Error(ErrorTypeConstants.InternalServerError, "An unexpected error occurred.");

    public static Error NotFoundError =>
        new Error(ErrorTypeConstants.NotFound, "Notification settings not found.");
}
