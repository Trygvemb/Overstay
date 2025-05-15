using FluentEmail.Core;
using Overstay.Application.Commons.Models;
using Overstay.Application.Services;

namespace Overstay.Infrastructure.Services;

public class EmailService(IFluentEmail fluentEmail, ILogger<EmailService> logger) : IEmailService
{
    public async Task SendUsingTemplateFromFile(
        EmailData emailMetadata,
        VisaNameAndDates user,
        string templateFile
    )
    {
        await fluentEmail
            .To(emailMetadata.RecipientEmail)
            .Subject(emailMetadata.Subject)
            .UsingTemplate(templateFile, user)
            .SendAsync();
    }

    public async Task SendEmailAsync(
        EmailData emailData,
        string? templateName = null,
        VisaNameAndDates? model = null
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

        logger.LogInformation(
            "templateName: {templateName}, Model: {model}, Name: {modelName}",
            templateName,
            model,
            model?.Name
        );

        var sendResponse = await fluentEmail
            .To(emailData.RecipientEmail)
            .Subject(emailData.Subject)
            .UsingTemplateFromFile(templateName, model)
            .SendAsync();
    }
}
