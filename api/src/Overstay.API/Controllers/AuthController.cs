using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Features.Users.Commands;
using Overstay.Application.Responses;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController(ISender mediator, SignInManager<ApplicationUser> signInManager) 
    : MediatorControllerBase(mediator)
{
    [HttpGet("external-login")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(string), StatusCodes.Status302Found)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ExternalLogin(string provider, string returnUrl = "/")
    {
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
        
        var redirectUrl = Url.Action(nameof(ExternalLoginCallback), "Auth", new { returnUrl });
        var properties = signInManager.ConfigureExternalAuthenticationProperties(validationResult.Value, redirectUrl);
        
        return Challenge(properties, validationResult.Value);
    }

    [HttpGet("external-login-callback")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(TokenResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status302Found)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ExternalLoginCallback(string returnUrl)
    {
        var result = await Mediator.Send(new ExternalLoginCallbackCommand(returnUrl));
        
        return result.IsSuccess ? Ok(result.Value) : HandleFailedResult(result);
    }
}