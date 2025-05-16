using Microsoft.EntityFrameworkCore;
using Overstay.Domain.Entities;
using Overstay.Infrastructure.Data.DbContexts;

namespace Overstay.IntegrationTest;

public class DatabaseTestFixture : IDisposable
{
    public DbContextOptions<ApplicationDbContext> DbContextOptions { get; }

    public DatabaseTestFixture()
    {
        DbContextOptions = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase("TestDatabase")
            .Options;

        SeedDatabase();
    }

    private void SeedDatabase()
    {
        using var context = new ApplicationDbContext(DbContextOptions);

        var testCountry = new Country
        {
            Id = Guid.NewGuid(),
            Name = "Test Country",
            IsoCode = "123",
        };

        var testUser = new User(testCountry.Id) { Id = Guid.NewGuid(), Country = testCountry };

        var testNotification = new Notification
        {
            Id = Guid.NewGuid(),
            UserId = testUser.Id,
            User = testUser,
            EmailNotification = true,
            PushNotification = true,
            SmsNotification = true,
            NintyDaysNotification = true,
            ExpiredNotification = true,
        };

        var testVisaType = new VisaType("TestVisaType", "Test Description", true)
        {
            Id = Guid.NewGuid(),
        };

        var testVisa = new Visa(DateTime.Now, DateTime.Now.AddDays(21))
        {
            Id = Guid.NewGuid(),
            User = testUser,
            UserId = testUser.Id,
            VisaType = testVisaType,
            VisaTypeId = testVisaType.Id,
        };

        context.Add(testCountry);
        context.Add(testUser);
        context.Add(testNotification);
        context.Add(testVisaType);
        context.Add(testVisa);
        context.SaveChanges();
    }

    public void Dispose()
    {
        using var context = new ApplicationDbContext(DbContextOptions);
        context.Database.EnsureDeleted();
    }
}
