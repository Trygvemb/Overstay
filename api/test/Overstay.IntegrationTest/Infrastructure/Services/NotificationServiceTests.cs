using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;
using Overstay.Application.Commons.Errors;
using Overstay.Domain.Entities;
using Overstay.Infrastructure.Data.DbContexts;
using Overstay.Infrastructure.Services;
using Shouldly;

namespace Overstay.IntegrationTest.Infrastructure.Services;

public class NotificationServiceTests(DatabaseTestFixture fixture)
    : IClassFixture<DatabaseTestFixture>
{
    [Fact]
    public async Task CreateNotificationSettings_ShouldReturnFailure_WhenNotificationAlreadyExists()
    {
        // Arrange
        await using var context = new ApplicationDbContext(fixture.DbContextOptions);
        var service = new NotificationService(context, NullLogger<NotificationService>.Instance);

        var existingNotification = await context.Notifications.FirstOrDefaultAsync();
        var newNotification = new Notification
        {
            Id = Guid.NewGuid(),
            UserId = existingNotification!.UserId,
            EmailNotification = true,
            PushNotification = true,
            SmsNotification = true,
            NintyDaysNotification = true,
            ExpiredNotification = true,
        };

        // Act
        var result = await service.CreateNotificationSettings(
            newNotification,
            CancellationToken.None
        );

        // Assert
        result.IsFailure.ShouldBeTrue();
        result.Error.ShouldBe(NotificationErrors.NotificationsAlreadyExists);
    }

    [Fact]
    public async Task CreateNotificationSettings_ShouldCreateNotification_WhenNoExistingNotification()
    {
        // Arrange
        await using var context = new ApplicationDbContext(fixture.DbContextOptions);
        var service = new NotificationService(context, NullLogger<NotificationService>.Instance);

        var newNotification = new Notification
        {
            Id = Guid.NewGuid(),
            UserId = Guid.NewGuid(), // New user ID
            EmailNotification = true,
            PushNotification = true,
            SmsNotification = true,
            NintyDaysNotification = true,
            ExpiredNotification = true,
        };

        // Act
        var result = await service.CreateNotificationSettings(
            newNotification,
            CancellationToken.None
        );

        // Assert
        result.IsSuccess.ShouldBeTrue();
        var createdNotification = await context.Notifications.FindAsync(newNotification.Id);
        createdNotification.ShouldNotBeNull();
        createdNotification.EmailNotification.ShouldBeTrue();
    }
}
