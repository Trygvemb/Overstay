using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Commons.Results;
using Overstay.Application.Features.Visas.Commands;
using Overstay.Application.Features.Visas.Queries;
using Overstay.Application.Features.Visas.Requests;
using Overstay.Application.Responses;
using Overstay.Infrastructure.Data.Identities;

namespace Overstay.API.Controllers;

public class VisaController(ISender mediator) : MediatorControllerBase(mediator)
{
    [HttpGet]
    [ProducesResponseType(typeof(List<VisaTypeResponse>), StatusCodes.Status200OK)]
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
        
        return result.IsSuccess
            ? Ok(result.Value)
            : HandleFailedResult(result);
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(VisaResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var userId = User.GetUserId();

        if (userId == null)
            return Unauthorized();

        var result = await Mediator.Send(new GetVisaQuery(id, userId.Value), cancellationToken);
        return result.IsSuccess
            ? Ok(result.Value)
            : HandleFailedResult(result);
    }

    [HttpPost]
    [ProducesResponseType(typeof(VisaResponse), StatusCodes.Status200OK)]
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
            ? CreatedAtAction(nameof(GetById), new { id = visaId }, visaId)
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

        return result.IsSuccess
            ? NoContent()
            : HandleFailedResult(result);
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

        return result.IsSuccess
            ? NoContent()
            : HandleFailedResult(result);
    }
}
