namespace Overstay.Application.Commons.Models;

public class EmailData(
    string recipientEmail,
    string subject,
    string? body,
    string? attachmentPath,
    string? templateName
)
{
    public string RecipientEmail { get; set; } = recipientEmail;
    public string Subject { get; set; } = subject;
    public string? Body { get; set; } = body;
    public string? AttachmentPath { get; set; } = attachmentPath;
    public string? TemplateName { get; set; } = templateName;
}
