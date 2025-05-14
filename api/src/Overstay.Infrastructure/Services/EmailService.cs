using FluentEmail.Core;
using Overstay.Application.Commons.Models;
using Overstay.Application.Services;

namespace Overstay.Infrastructure.Services;

public class EmailService(IFluentEmail fluentEmail) : IEmailService
{
    public async Task SendEmailAsync(EmailData emailData)
    {
        await fluentEmail
            .To(emailData.RecipientEmail)
            .Subject(emailData.Subject)
            .UsingTemplateFromFile(emailData.TemplateName, emailData.Body)
            .SendAsync();
    }
}
