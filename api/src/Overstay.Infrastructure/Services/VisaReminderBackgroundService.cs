using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Overstay.Application.Commons.Models;
using Overstay.Application.Services;

namespace Overstay.Infrastructure.Services;

public class VisaReminderBackgroundService(
    IServiceProvider serviceProvider,
    ILogger<VisaReminderBackgroundService> logger,
    ITimezoneProvider timezoneProvider
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

                await ProcessVisaRemindersAsync(visaService, emailService, cancellationToken);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "An unexpected error occurred in the visa reminder job");
            }

            await Task.Delay(TimeSpan.FromDays(1), cancellationToken);
        }
    }

    private async Task ProcessVisaRemindersAsync(
        IVisaService visaService,
        IEmailService emailService,
        CancellationToken cancellationToken
    )
    {
        var visaNotificationsResult = await visaService.GetVisaEmailNotificationsAsync(
            cancellationToken
        );

        if (visaNotificationsResult.IsFailure)
        {
            logger.LogError(
                "Failed to retrieve visa notifications: {Error}",
                visaNotificationsResult.Error
            );
            return;
        }

        var currentDateTime = timezoneProvider.GetCurrentTimeInThailand();

        foreach (var notification in visaNotificationsResult.Value)
        {
            await ProcessNotificationAsync(notification, emailService, currentDateTime);
        }
    }

    private async Task ProcessNotificationAsync(
        UserNotificationsAndVisas notification,
        IEmailService emailService,
        DateTime currentDateTime
    )
    {
        var daysBeforeTimeSpan = TimeSpan.FromDays(notification.DaysBefore);

        foreach (var visa in notification.Visas)
        {
            if (ShouldSendExpiredReminder(notification, visa, currentDateTime, daysBeforeTimeSpan))
            {
                var emailTemplatePath = GetTemplatePath(
                    expiredNotification: true,
                    nintyDaysNotification: false
                );
                await SendEmailAsync(notification, visa, emailService, emailTemplatePath);
            }
            else if (
                ShouldSendNintyDaysReminder(notification, visa, currentDateTime, daysBeforeTimeSpan)
            )
            {
                var emailTemplatePath = GetTemplatePath(
                    expiredNotification: false,
                    nintyDaysNotification: true
                );
                await SendEmailAsync(notification, visa, emailService, emailTemplatePath);
            }
        }
    }

    private static bool ShouldSendExpiredReminder(
        UserNotificationsAndVisas notification,
        VisaNameAndDates visa,
        DateTime currentDateTime,
        TimeSpan daysBeforeTimeSpan
    )
    {
        var currentDate = currentDateTime.Date;
        var visaExpireNotificationDate = visa.ExpireDate.Date - daysBeforeTimeSpan;

        return notification.ExpiredNotification && currentDate == visaExpireNotificationDate;
    }

    private static bool ShouldSendNintyDaysReminder(
        UserNotificationsAndVisas notification,
        VisaNameAndDates visa,
        DateTime currentDateTime,
        TimeSpan daysBeforeTimeSpan
    )
    {
        return notification.NintyDaysNotification
            && currentDateTime.Date
                == visa.ArrivalDate.Date - daysBeforeTimeSpan + TimeSpan.FromDays(90);
    }

    private async Task SendEmailAsync(
        UserNotificationsAndVisas notification,
        VisaNameAndDates visa,
        IEmailService emailService,
        string emailTemplatePath
    )
    {
        var emailData = new EmailData
        {
            RecipientEmail = notification.Email,
            Subject = "Visa Reminder",
        };

        try
        {
            await emailService.SendEmailAsync(emailData, emailTemplatePath, visa);
            logger.LogInformation(
                "Email sent to {RecipientEmail} for visa {VisaName}",
                notification.Email,
                visa.Name
            );
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to send email to {RecipientEmail}", notification.Email);
        }
    }

    private static string GetTemplatePath(bool expiredNotification, bool nintyDaysNotification)
    {
        var templateName =
            expiredNotification ? "VisaExpiredTemplate.cshtml"
            : nintyDaysNotification ? "VisaNintyDaysTemplate.cshtml"
            : throw new ArgumentException("Invalid notification type");

        var templatePath =
            $"{Directory.GetCurrentDirectory()}/../Overstay.Infrastructure/Data/Templates/{templateName}";

        if (!File.Exists(templatePath))
        {
            throw new FileNotFoundException($"Template file not found at path: {templatePath}");
        }

        return templatePath;
    }
}
