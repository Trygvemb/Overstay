using Microsoft.EntityFrameworkCore;
using Overstay.Infrastructure.Data.DbContexts;
using Xunit;

namespace Overstay.IntegrationTest;

public class IntegrationTests : IClassFixture<DatabaseTestFixture>
{
    private readonly DatabaseTestFixture _fixture;

    public IntegrationTests(DatabaseTestFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task TestWithMockData()
    {
        await using var context = new ApplicationDbContext(_fixture.DbContextOptions);

        // Act
        var country = await context.Countries.FirstOrDefaultAsync();
        var user = await context.Users.FirstOrDefaultAsync();
        var notification = await context.Notifications.FirstOrDefaultAsync();
        var visaType = await context.VisaTypes.FirstOrDefaultAsync();
        var visa = await context.Visas.FirstOrDefaultAsync();

        // Assert
        Assert.NotNull(country);
        Assert.NotNull(user);
        Assert.NotNull(notification);
        Assert.NotNull(visaType);
        Assert.NotNull(visa);
        Assert.Equal(country.Id, user.CountryId);
        Assert.Equal(visaType.Id, visa.VisaTypeId);
        Assert.Equal(user.Id, visa.UserId);
        Assert.Equal(user.Id, notification.UserId);
    }
}
