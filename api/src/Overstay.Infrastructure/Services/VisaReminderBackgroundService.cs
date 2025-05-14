using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Models;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;
using Overstay.Domain.Constants;

namespace Overstay.Infrastructure.Services;

public class VisaReminderBackgroundService(
    IServiceProvider serviceProvider,
    ILogger<VisaReminderBackgroundService> logger
) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        while (!cancellationToken.IsCancellationRequested)
        {
            try
            {
                logger.LogInformation(
                    "Running daily visa reminder job at {time}",
                    DateTimeOffset.Now
                );

                using var scope = serviceProvider.CreateScope();
                var visaService = scope.ServiceProvider.GetRequiredService<IVisaService>();
                var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>();

                var visaReminders = await SendReminderAsync(
                    visaService,
                    emailService,
                    cancellationToken
                );

                if (visaReminders.IsFailure)
                {
                    logger.LogError(
                        "An error occurred while sending visa reminders: {Error}",
                        visaReminders.Error
                    );
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, "An error occurred while running the visa reminder job");
            }

            await Task.Delay(TimeSpan.FromDays(1), cancellationToken);
        }
    }

    private async Task<Result> SendReminderAsync(
        IVisaService visaService,
        IEmailService emailService,
        CancellationToken cancellation
    )
    {
        var responseResult = await visaService.GetVisaEmailNotificationsAsync(cancellation);

        if (responseResult.IsFailure)
        {
            logger.LogError(
                "An error occurred while retrieving visa email notifications: {Error}",
                responseResult.Error
            );
            return Result.Failure(responseResult.Error);
        }

        try
        {
            var currenDateTime = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
                DateTime.UtcNow,
                Constant.ThailandTimezoneId
            );

            foreach (var notification in responseResult.Value)
            {
                var daysBeforeTimeSpan = TimeSpan.FromDays(notification.DaysBefore);

                foreach (
                    var visa in notification.Visas.Where(visa =>
                        notification.ExpiredNotification
                            && currenDateTime == visa.ExpireDate - daysBeforeTimeSpan
                        || notification.NintyDaysNotification
                            && currenDateTime
                                == visa.ArrivalDate - daysBeforeTimeSpan + TimeSpan.FromDays(90)
                    )
                )
                {
                    var emailData = new EmailData
                    {
                        RecipientEmail = notification.Email,
                        Subject = "Visa Reminder",
                        TemplateName = GetTemplatePath(
                            notification.ExpiredNotification,
                            notification.NintyDaysNotification
                        ),
                        Body = JsonSerializer.Serialize(
                            new
                            {
                                VisaName = visa.Name,
                                ExpireDate = visa.ExpireDate.ToString("yyyy-MM-dd"),
                                ArrivalDate = visa.ArrivalDate.ToString("yyyy-MM-dd"),
                            }
                        ),
                    };

                    await emailService.SendEmailAsync(emailData);
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

    private string GetTemplatePath(bool expiredNotification, bool nintyDaysNotification)
    {
        var templateName =
            expiredNotification ? "VisaExpiredTemplate"
            : nintyDaysNotification ? "VisaNintyDaysTemplate"
            : throw new ArgumentException("Invalid notification type");

        var templatePath = Path.Combine(
            AppContext.BaseDirectory,
            "src",
            "Overstay.Infrastructure",
            "Data",
            "Templates",
            $"{templateName}.cshtml"
        );

        if (!File.Exists(templatePath))
        {
            throw new FileNotFoundException($"Template file '{templateName}' not found.");
        }

        return templatePath;
    }
}
