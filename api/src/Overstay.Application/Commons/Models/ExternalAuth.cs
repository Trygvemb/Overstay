namespace Overstay.Application.Commons.Models;

public record ExternalAuth
{
    public string? RedirectUrl { get; init; }
    public TokenResponse? Token { get; init; }
}
