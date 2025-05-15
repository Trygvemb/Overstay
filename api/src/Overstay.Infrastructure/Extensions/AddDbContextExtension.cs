using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Overstay.Infrastructure.Configurations;
using Overstay.Infrastructure.Data.DbContexts;

namespace Overstay.Infrastructure.Extensions;

public static class AddDbContextExtension
{
    public static void AddDbContext(
        this IServiceCollection services,
        ConfigurationManager configuration
    )
    {
        var dbOptions = DatabaseOptions.Load(configuration);

        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(
                dbOptions.ConnectionString,
                mysqlOptions =>
                {
                    mysqlOptions.MigrationsAssembly("Overstay.Infrastructure");
                    mysqlOptions.EnableRetryOnFailure();
                    mysqlOptions.CommandTimeout(60);
                }
            )
        );
    }
}
