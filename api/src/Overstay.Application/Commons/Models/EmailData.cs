namespace Overstay.Application.Commons.Models;

public class EmailData
{
    public string RecipientEmail { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string? Body { get; set; }
}
