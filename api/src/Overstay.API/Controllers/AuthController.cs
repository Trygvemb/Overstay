using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Features.Users.Commands;
using Overstay.Application.Responses;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.API.Controllers;

public class AuthController(ISender mediator, SignInManager<ApplicationUser> signInManager, ILogger<AuthController> logger) 
    : MediatorControllerBase(mediator)
{
    [HttpGet("external-login")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(string), StatusCodes.Status302Found)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ExternalLogin(string provider, string? returnUrl = null)
    {
        logger.LogInformation("Starting external login flow for provider: {Provider}, returnUrl: {ReturnUrl}", 
            provider, returnUrl);

        if (string.IsNullOrEmpty(provider))
        {
            return BadRequest(new { error = "Provider parameter is required" });
        }

        // Validate provider
        var validationResult = await Mediator.Send(new ExternalLoginCommand(provider, returnUrl));
        if (validationResult.IsFailure)
        {
            return HandleFailedResult(validationResult);
        }

        var validatedProvider = validationResult.Value;
    
        // Ensure returnUrl is safe
        if (!string.IsNullOrEmpty(returnUrl) && !Url.IsLocalUrl(returnUrl) && 
            !Uri.TryCreate(returnUrl, UriKind.Absolute, out _))
        {
            returnUrl = "/";
        }
    
        // Store returnUrl in session
        HttpContext.Session.SetString("oauth_return_url", returnUrl ?? "/");
    
        // Generate callback URL - IMPORTANT: must match what's configured in Google console
        var callbackUrl = Url.Action(
            action: nameof(ExternalLoginCallback),
            controller: "Auth",
            values: null,
            protocol: Request.Scheme);
    
        logger.LogInformation("Generated callback URL: {CallbackUrl}", callbackUrl);
    
        // Configure properties
        var properties = signInManager.ConfigureExternalAuthenticationProperties(
            validatedProvider, callbackUrl);
    
        // Store returnUrl in properties
        properties.Items["returnUrl"] = returnUrl ?? "/";
    
        // Issue challenge - this will redirect the browser, not send a CORS request
        return Challenge(properties, validatedProvider);
    }

    [HttpGet("external-login-callback")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(TokenResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status302Found)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ExternalLoginCallback(string? returnUrl = null, string? remoteError = null)
    {
        logger.LogInformation("Received callback from external provider. RemoteError: {RemoteError}, ReturnUrl: {ReturnUrl}", 
            remoteError, returnUrl);

        if (string.IsNullOrEmpty(returnUrl))
        {
            var authenticateResult = await HttpContext.AuthenticateAsync(IdentityConstants.ExternalScheme);
            returnUrl = authenticateResult?.Properties?.Items["returnUrl"] ?? "/";
            
            logger.LogInformation("Retrieved returnUrl from auth properties: {ReturnUrl}", returnUrl);
        }
        
        var result = await Mediator.Send(new ExternalLoginCallbackCommand(returnUrl, remoteError));
        
        if (result.IsFailure)
        {
            // For API clients, return error. For browser clients, consider redirecting to the error page
            return Request.Headers.Accept.Any(h => h!.Contains("application/json")) 
                ? HandleFailedResult(result) 
                : Redirect($"/auth-error?error={Uri.EscapeDataString(result.Error.Message ?? "Unknown error")}");
        }

        var response = result.Value;

        // If we have a redirect URL, use it
        if (!string.IsNullOrEmpty(response.RedirectUrl))
        {
            // Optionally append token as URL parameter for SPAs
            // This could be done securely with a temporary code that SPAs can exchange for a token
            // For simplicity, we're just redirecting
            return Redirect(response.RedirectUrl);
        }

        // Return token directly (useful for API clients)
        return Ok(response.Token);
    }
    
    [HttpGet("auth-error")]
    [AllowAnonymous]
    public IActionResult AuthError(string error)
    {
        logger.LogWarning("Auth error: {Error}", error);
    
        // Instead of returning a custom page, throw an exception
        // which will be rendered by the developer exception page
        throw new Exception($"Authentication Error: {error}");
    }
}