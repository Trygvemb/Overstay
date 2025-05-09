using Microsoft.EntityFrameworkCore.Query;
using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Results;
using Overstay.Application.Responses;
using Overstay.Application.Services;
using Overstay.Domain.Constants;
using Overstay.Infrastructure.Data.DbContexts;

namespace Overstay.Infrastructure.Services;

public class VisaService(ApplicationDbContext context, ILogger<VisaService> logger) : IVisaService
{
    public async Task<Result<List<Visa>>> GetAllAsync(
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        try
        {
            logger.LogInformation("Retrieving all visa records");
            var visas = await context
                .Visas.Where(v => v.UserId == userId)
                .Include(v => v.VisaType)
                .ToListAsync(cancellationToken);

            return Result.Success(visas);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving all visa records");
            return Result.Failure<List<Visa>>(Error.ServerError);
        }
    }

    public async Task<Result<Visa>> GetByIdAsync(
        Guid id,
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        try
        {
            logger.LogInformation("Retrieving visa with ID {VisaId}", id);
            var visa = await context
                .Visas.Include(v => v.VisaType)
                .FirstOrDefaultAsync(v => v.Id == id, cancellationToken);

            if (visa != null && visa.UserId != userId)
                return Result.Failure<Visa>(UserErrors.AccessDenied);

            return visa is null
                ? Result.Failure<Visa>(VisaErrors.NotFound(id))
                : Result.Success(visa);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving visa with ID {VisaId}", id);
            return Result.Failure<Visa>(Error.ServerError);
        }
    }

    public async Task<Result<Guid>> CreateAsync(Visa visa, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Creating new visa");
            await context.Visas.AddAsync(visa, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success(visa.Id);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while creating visa type");
            return Result.Failure<Guid>(VisaErrors.FailedToCreateVisa);
        }
    }

    public async Task<Result> UpdateAsync(Visa visa, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Updating visa type with ID {VisaId}", visa.Id);
            var existingType = await context.Visas.FindAsync([visa.Id], cancellationToken);

            if (existingType is null)
                return Result.Failure(VisaErrors.NotFound(visa.Id));

            context.Entry(existingType).CurrentValues.SetValues(visa);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success();
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result.Failure(VisaErrors.ConcurrencyError);
        }
        catch (Exception ex)
        {
            logger.LogError(
                ex,
                "An error occurred while updating visa type with ID {VisaId}",
                visa.Id
            );
            return Result.Failure(Error.ServerError);
        }
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Deleting visa with ID {VisaId}", id);
            var visa = await context.Visas.FindAsync([id], cancellationToken);

            if (visa is null)
                return Result.Failure(VisaErrors.NotFound(id));

            context.Visas.Remove(visa);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while deleting visa with ID {VisaId}", id);
            return Result.Failure(Error.ServerError);
        }
    }

    public async Task<Result> SendReminderAsync(CancellationToken cancellation)
    {
        var responseResult = await GetVisaEmailNotificationsAsync(cancellation);

        if (responseResult.IsFailure)
        {
            logger.LogError(
                "An error occurred while retrieving visa email notifications: {Error}",
                responseResult.Error
            );
            return Result.Failure(responseResult.Error);
        }

        var currenDateTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
            DateTime.UtcNow,
            Constant.ThailandTimezoneId
        );
        var visaEmailNotifications = responseResult.Value;

        try
        {
            foreach (var notification in visaEmailNotifications)
            {
                var visaName = notification.Name;
                var email = notification.Email;
                var userName = notification.UserName;
                var visas = notification.Visas;
                var daysBeforeTimeSpan = TimeSpan.FromDays(notification.DaysBefore);
                var expiredNotification = notification.ExpiredNotification;
                var nintyDaysNotification = notification.NintyDaysNotification;

                foreach (var visa in visas)
                {
                    if (
                        expiredNotification
                        && currenDateTime == visa.ExpireDate - daysBeforeTimeSpan
                    )
                    {
                        // Send email for expired notification
                        await SendEmailAsync(
                            email,
                            userName,
                            visaName,
                            expiredNotification,
                            nintyDaysNotification,
                            cancellation
                        );
                    }

                    if (
                        nintyDaysNotification
                        && currenDateTime
                            == visa.ArrivalDate - daysBeforeTimeSpan + TimeSpan.FromDays(90)
                    )
                    {
                        // Send email for 90 days notification
                        await SendEmailAsync(
                            email,
                            userName,
                            visaName,
                            expiredNotification,
                            nintyDaysNotification,
                            cancellation
                        );
                    }
                }
            }

            return Result.Success();
        }
        catch (Exception e)
        {
            logger.LogError(e, "An error occurred while sending email notifications");
            return Result.Failure(Error.ServerError);
        }
    }

    private async Task<Result<List<VisaEmailNotificationsResponse>>> GetVisaEmailNotificationsAsync(
        CancellationToken cancellationToken
    )
    {
        try
        {
            var visas = await context
                .Visas.Where(v =>
                    v.IsActive
                    && v.User.Notification != null
                    && v.User.Notification.EmailNotification == true
                )
                .Include(v => v.VisaType)
                .Include(v => v.User)
                .ThenInclude(u => u.Notification)
                .Join(
                    context.ApplicationUsers,
                    visa => visa.UserId,
                    appUser => appUser.Id,
                    (visa, appUser) =>
                        new
                        {
                            appUser.Email,
                            appUser.UserName,
                            visa.ArrivalDate,
                            visa.ExpireDate,
                            visa.VisaType.Name,
                            visa.User.Notification!.DaysBefore,
                            visa.User.Notification.ExpiredNotification,
                            visa.User.Notification.NintyDaysNotification,
                        }
                )
                .GroupBy(x => new { x.Email, x.UserName })
                .Select(group => new VisaEmailNotificationsResponse
                {
                    Name = group.First().Name!,
                    Email = group.Key.Email!,
                    UserName = group.Key.UserName!,
                    DaysBefore = group.First().DaysBefore,
                    ExpiredNotification = group.First().ExpiredNotification,
                    NintyDaysNotification = group.First().NintyDaysNotification,
                    Visas = group
                        .Select(v => new VisaNotificationResponse
                        {
                            ArrivalDate = v.ArrivalDate,
                            ExpireDate = v.ExpireDate,
                        })
                        .ToList(),
                })
                .ToListAsync(cancellationToken);

            return Result.Success(visas);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving visa email notifications");
            return Result.Failure<List<VisaEmailNotificationsResponse>>(Error.ServerError);
        }
    }

    private async Task SendEmailAsync(
        string email,
        string userName,
        string visaName,
        bool expiredNotification,
        bool nintyDaysNotification,
        CancellationToken cancellation
    )
    {
        if (expiredNotification)
        {
            // Send email for expired notification
            // await emailService.SendVisaExpiredNotificationAsync(
            //     email,
            //     userName,
            //     visaName,
            //     cancellation
            // );
        }

        if (nintyDaysNotification)
        {
            // Send email for 90 days notification
            // await emailService.SendVisaNintyDaysNotificationAsync(
            //     email,
            //     userName,
            //     visaName,
            //     cancellation
            // );
        }
    }
}
