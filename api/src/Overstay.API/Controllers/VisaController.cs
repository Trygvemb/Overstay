using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Visas.Commands;
using Overstay.Application.Features.Visas.Queries;
using Overstay.Application.Features.Visas.Requests;
using Overstay.Application.Features.Visas.Responses;
using Overstay.Application.Features.VisaTypes.Responses;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.API.Controllers;

public class VisaController(ISender mediator) : MediatorControllerBase(mediator)
{
    [HttpGet("all")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
    {
        var userId = User.GetUserId();

        if (userId == null)
            return Unauthorized();

        var result = await Mediator.Send(new GetAllVisasQuery(userId.Value), cancellationToken);

        return result.IsSuccess ? Ok(result.Value) : HandleFailedResult(result);
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetActiveVisa(CancellationToken cancellationToken)
    {
        var userId = User.GetUserId();

        if (userId == null)
            return Unauthorized();

        var result = await Mediator.Send(new GetVisaQuery(userId.Value), cancellationToken);
        return result.IsSuccess ? Ok(result.Value) : HandleFailedResult(result);
    }

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Create(
        CreateVisaRequest request,
        CancellationToken cancellationToken
    )
    {
        var userId = User.GetUserId();

        if (userId == null)
            return Unauthorized();

        var result = await Mediator.Send(
            new CreateVisaCommand(request, userId.Value),
            cancellationToken
        );

        var visaId = result.GetValue<Guid>();

        return result.IsSuccess
            ? CreatedAtAction(nameof(GetActiveVisa), new { id = visaId }, visaId)
            : HandleFailedResult(result);
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update(
        Guid id,
        UpdateVisaRequest request,
        CancellationToken cancellationToken
    )
    {
        var result = await Mediator.Send(new UpdateVisaCommand(id, request), cancellationToken);

        return result.IsSuccess ? NoContent() : HandleFailedResult(result);
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new DeleteVisaCommand(id), cancellationToken);

        return result.IsSuccess ? NoContent() : HandleFailedResult(result);
    }
}
