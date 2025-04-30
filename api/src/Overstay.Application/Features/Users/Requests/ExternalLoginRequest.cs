namespace Overstay.Application.Features.Users.Requests;

public sealed record ExternalLoginCallbackRequest(string? ReturnUrl = null, string? RemoteError = null);
