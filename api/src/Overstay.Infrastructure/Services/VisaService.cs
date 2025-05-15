using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Models;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;
using Overstay.Domain.Constants;
using Overstay.Infrastructure.Data.DbContexts;

namespace Overstay.Infrastructure.Services;

public class VisaService(ApplicationDbContext context, ILogger<VisaService> logger) : IVisaService
{
    public async Task<Result<List<Visa>>> GetAllAsync(
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        try
        {
            logger.LogInformation("Retrieving all visa records");
            var visas = await context
                .Visas.Where(v => v.UserId == userId)
                .Include(v => v.VisaType)
                .ToListAsync(cancellationToken);

            return Result.Success(visas);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving all visa records");
            return Result.Failure<List<Visa>>(Error.ServerError);
        }
    }

    public async Task<Result<Visa>> GetByIdAsync(
        Guid id,
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        try
        {
            logger.LogInformation("Retrieving visa with ID {VisaId}", id);
            var visa = await context
                .Visas.Include(v => v.VisaType)
                .FirstOrDefaultAsync(v => v.Id == id, cancellationToken);

            if (visa != null && visa.UserId != userId)
                return Result.Failure<Visa>(UserErrors.AccessDenied);

            return visa is null
                ? Result.Failure<Visa>(VisaErrors.NotFound(id))
                : Result.Success(visa);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving visa with ID {VisaId}", id);
            return Result.Failure<Visa>(Error.ServerError);
        }
    }

    public async Task<Result<Guid>> CreateAsync(Visa visa, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Creating new visa");
            await context.Visas.AddAsync(visa, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success(visa.Id);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while creating visa type");
            return Result.Failure<Guid>(VisaErrors.FailedToCreateVisa);
        }
    }

    public async Task<Result> UpdateAsync(Visa visa, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Updating visa type with ID {VisaId}", visa.Id);
            var existingType = await context.Visas.FindAsync([visa.Id], cancellationToken);

            if (existingType is null)
                return Result.Failure(VisaErrors.NotFound(visa.Id));

            context.Entry(existingType).CurrentValues.SetValues(visa);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success();
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result.Failure(VisaErrors.ConcurrencyError);
        }
        catch (Exception ex)
        {
            logger.LogError(
                ex,
                "An error occurred while updating visa type with ID {VisaId}",
                visa.Id
            );
            return Result.Failure(Error.ServerError);
        }
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Deleting visa with ID {VisaId}", id);
            var visa = await context.Visas.FindAsync([id], cancellationToken);

            if (visa is null)
                return Result.Failure(VisaErrors.NotFound(id));

            context.Visas.Remove(visa);
            await context.SaveChangesAsync(cancellationToken);

            return Result.Success();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while deleting visa with ID {VisaId}", id);
            return Result.Failure(Error.ServerError);
        }
    }

    public async Task<Result<List<UserNotificationsAndVisas>>> GetVisaEmailNotificationsAsync(
        CancellationToken cancellationToken
    )
    {
        try
        {
            var visas = await context
                .Visas.Where(v =>
                    v.IsActive
                    && v.User.Notification != null
                    && v.User.Notification.EmailNotification == true
                )
                .Include(v => v.VisaType)
                .Include(v => v.User)
                .ThenInclude(u => u.Notification)
                .Join(
                    context.ApplicationUsers,
                    visa => visa.UserId,
                    appUser => appUser.Id,
                    (visa, appUser) =>
                        new
                        {
                            appUser.Email,
                            appUser.UserName,
                            visa.ArrivalDate,
                            visa.ExpireDate,
                            visa.VisaType.Name,
                            visa.User.Notification!.DaysBefore,
                            visa.User.Notification.ExpiredNotification,
                            visa.User.Notification.NintyDaysNotification,
                        }
                )
                .GroupBy(x => new { x.Email, x.UserName })
                .Select(group => new UserNotificationsAndVisas
                {
                    Email = group.Key.Email!,
                    UserName = group.Key.UserName!,
                    DaysBefore = group.First().DaysBefore,
                    ExpiredNotification = group.First().ExpiredNotification,
                    NintyDaysNotification = group.First().NintyDaysNotification,
                    Visas = group
                        .Select(v => new VisaNameAndDates
                        {
                            Name = group.First().Name!,
                            ArrivalDate = v.ArrivalDate,
                            ExpireDate = v.ExpireDate,
                        })
                        .ToList(),
                })
                .ToListAsync(cancellationToken);

            return Result.Success(visas);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while retrieving visa email notifications");
            return Result.Failure<List<UserNotificationsAndVisas>>(Error.ServerError);
        }
    }
}
