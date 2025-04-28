namespace Overstay.Application.Features.Users.Requests;

public sealed record ExternalLoginCallbackRequest(string? RemoteError = null, string? ReturnUrl = null);
