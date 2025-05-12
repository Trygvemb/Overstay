using Overstay.Application.Commons.Models;

namespace Overstay.Application.Services;

public interface IEmailService
{
    Task SendEmail(EmailData emailData);
}
