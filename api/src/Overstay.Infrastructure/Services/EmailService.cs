using FluentEmail.Core;
using Overstay.Application.Commons.Models;
using Overstay.Application.Services;

namespace Overstay.Infrastructure.Services;

public class EmailService(IFluentEmail fluentEmail, ILogger<EmailService> logger) : IEmailService
{
    public async Task SendEmailAsync(
        EmailData emailData,
        string? templateName = null,
        object? model = null
    )
    {
        if (string.IsNullOrWhiteSpace(templateName))
        {
            await fluentEmail
                .To(emailData.RecipientEmail)
                .Subject(emailData.Subject)
                .Body(emailData.Body)
                .SendAsync();
            return;
        }

        if (Email.DefaultRenderer == null)
        {
            logger.LogError("Email renderer is not initialized.");
            return;
        }

        await fluentEmail
            .To(emailData.RecipientEmail)
            .Subject(emailData.Subject)
            .UsingTemplateFromFile(templateName, model)
            .SendAsync();
    }
}
