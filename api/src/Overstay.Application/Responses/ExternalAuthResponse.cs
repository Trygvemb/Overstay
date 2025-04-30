namespace Overstay.Application.Responses;

public record ExternalAuthResponse
{
   // public bool Succeeded { get; init; }
    public string? RedirectUrl { get; init; }
    public TokenResponse? Token { get; init; }
    //public string? Error { get; init; }
}
