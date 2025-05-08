using Mapster;
using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Features.Notifications.Commands;
using Overstay.Application.Features.Notifications.Queries;
using Overstay.Application.Features.Notifications.Requests;
using Overstay.Application.Features.Notifications.Responses;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.API.Controllers;

public class NotificationController(ISender mediator) : MediatorControllerBase(mediator)
{
    [HttpPost]
    [ProducesResponseType(typeof(Guid), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<IActionResult> CreateNotificationSettings(
        NotificationRequest request,
        CancellationToken cancellationToken
    )
    {
        var currentUserId = User.GetUserId();
        if (currentUserId == null)
            return Unauthorized();

        var command = request.Adapt<CreateNotificationSettingsCommand>();
        command = command with { UserId = currentUserId.Value };

        var result = await Mediator.Send(command, cancellationToken);

        return result.IsSuccess
            ? CreatedAtAction(nameof(GetNotificationSettings), new { currentUserId }, result.Value)
            : HandleFailedResult(result);
    }

    [HttpGet]
    [ProducesResponseType(typeof(NotificationSettingsResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetNotificationSettings(CancellationToken cancellationToken)
    {
        var userId = User.GetUserId();
        if (userId == null)
            return Unauthorized();

        var query = new GetNotificationSettingsQuery(userId.Value);
        var result = await Mediator.Send(query, cancellationToken);

        return result.IsSuccess ? Ok(result.Value) : HandleFailedResult(result);
    }

    [HttpPut]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<IActionResult> UpdateNotificationSettings(
        NotificationRequest request,
        CancellationToken cancellationToken
    )
    {
        var currentUserId = User.GetUserId();
        if (currentUserId == null)
            return Unauthorized();

        var command = request.Adapt<UpdateNotificationSettingsCommand>();
        command = command with { UserId = currentUserId.Value };

        var result = await Mediator.Send(command, cancellationToken);

        return result.IsSuccess ? Ok(result) : HandleFailedResult(result);
    }
}
