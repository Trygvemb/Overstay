using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Overstay.Application.Commons.Constants;
using Overstay.Application.Features.VisaTypes.Commands;
using Overstay.Application.Features.VisaTypes.Queries;
using Overstay.Application.Features.VisaTypes.Requests;
using Overstay.Application.Responses;

namespace Overstay.API.Controllers;

public class VisaTypeController(ISender mediator) : MediatorControllerBase(mediator)
{
    [HttpGet]
    [Authorize]
    [ProducesResponseType(typeof(List<VisaTypeResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new GetVisaTypesQuery(), cancellationToken);
        
        return result.IsSuccess
            ? Ok(result.Value)
            : HandleFailedResult(result);
    }

    [HttpGet("{id:guid}")]
    [Authorize]
    [ProducesResponseType(typeof(Guid), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new GetVisaTypeQuery(id), cancellationToken);
        
        return result.IsSuccess
            ? Ok(result.Value)
            : HandleFailedResult(result);
    }

    [HttpPost]
    [Authorize(Roles = RoleTypeConstants.Admin)]
    [ProducesResponseType(typeof(VisaTypeResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Create(
        CreateVisaTypeCommand command,
        CancellationToken cancellationToken
    )
    {
        var result = await Mediator.Send(command, cancellationToken);
        
        return result.IsSuccess
            ? CreatedAtAction(nameof(GetById), new { id = result.Value }, result.Value)
            : HandleFailedResult(result);
    }

    [HttpPut("{id:guid}")]
    [Authorize(Roles = RoleTypeConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update(
        Guid id,
        UpdateVisaTypeRequest request,
        CancellationToken cancellationToken
    )
    {
        var result = await Mediator.Send(new UpdateVisaTypeCommand(id, request), cancellationToken);

        return result.IsSuccess
            ? NoContent()
            : HandleFailedResult(result);
    }

    [HttpDelete("{id:guid}")]
    [Authorize(Roles = RoleTypeConstants.Admin)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new DeleteVisaTypeCommand(id), cancellationToken);
        
        return result.IsSuccess
            ? NoContent()
            : HandleFailedResult(result);
    }
}
