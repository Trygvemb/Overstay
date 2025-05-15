using Overstay.Application.Commons.Models;

namespace Overstay.Application.Services;

public interface IEmailService
{
    Task SendEmailAsync(EmailData emailData, string? templateName = null, object? model = null);
}
