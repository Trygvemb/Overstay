using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Moq;
using Overstay.Application.Commons.Errors;
using Overstay.Application.Commons.Models;
using Overstay.Application.Commons.Results;
using Overstay.Application.Services;
using Overstay.Infrastructure.Services;

namespace Overstay.UnitTest.Infrastructure.Services;

public class VisaReminderBackgroundServiceTests
{
    [Fact]
    public async Task ExecuteAsync_ShouldLogError_WhenVisaServiceFails()
    {
        // Arrange
        var visaServiceMock = new Mock<IVisaService>();
        var emailServiceMock = new Mock<IEmailService>();
        var loggerMock = new Mock<ILogger<VisaReminderBackgroundService>>();
        var serviceProviderMock = new Mock<IServiceProvider>();

        visaServiceMock
            .Setup(v => v.GetVisaEmailNotificationsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(
                Result.Failure<List<UserNotificationsAndVisas>>(new Error("Visa service error"))
            );

        serviceProviderMock
            .Setup(sp => sp.CreateScope())
            .Returns(
                Mock.Of<IServiceScope>(scope =>
                    scope.ServiceProvider
                    == Mock.Of<IServiceProvider>(sp =>
                        sp.GetService(typeof(IVisaService)) == visaServiceMock.Object
                        && sp.GetService(typeof(IEmailService)) == emailServiceMock.Object
                    )
                )
            );

        var service = new VisaReminderBackgroundService(
            serviceProviderMock.Object,
            loggerMock.Object
        );

        // Act
        await service.StartAsync(CancellationToken.None);

        // Assert
        loggerMock.Verify(
            l =>
                l.Log(
                    LogLevel.Error,
                    It.IsAny<EventId>(),
                    It.Is<It.IsAnyType>((v, t) => v.ToString().Contains("Error")),
                    It.IsAny<Exception>(),
                    It.IsAny<Func<It.IsAnyType, Exception, string>>()
                ),
            Times.Once
        );
    }
}
