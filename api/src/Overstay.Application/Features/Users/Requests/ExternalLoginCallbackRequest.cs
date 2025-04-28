namespace Overstay.Application.Features.Users.Requests;

public sealed record ExternalLoginRequest(string Provider, string? ReturnUrl = null);
