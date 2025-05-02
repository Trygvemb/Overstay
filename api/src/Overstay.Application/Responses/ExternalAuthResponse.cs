namespace Overstay.Application.Responses;

public record ExternalAuthResponse
{
    public string? RedirectUrl { get; init; }
    public TokenResponse? Token { get; init; }
}
