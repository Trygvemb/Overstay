namespace Overstay.Application.Features.Authentications;

public sealed record ExternalLoginRequest(string Provider, string? ReturnUrl = null);

public sealed record ExternalLoginCallbackRequest(string? RemoteError = null, string? ReturnUrl = null);
