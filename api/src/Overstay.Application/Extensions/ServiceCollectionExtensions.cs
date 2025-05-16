using System.Reflection;
using FluentValidation;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using Overstay.Application.Commons.Behaviors;
using Overstay.Application.Commons.Configurations;
using Overstay.Application.Commons.Helpers;

namespace Overstay.Application.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApplicationLayer(this IServiceCollection services)
    {
        services.AddValidatorsFromAssembly(
            Assembly.GetExecutingAssembly(),
            includeInternalTypes: true
        );

        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
        });

        MappingConfigurations.Configure();

        services.AddSingleton(TypeAdapterConfig.GlobalSettings);
        services.AddScoped<IMapper, Mapper>();
        services.AddSingleton<ITimezoneProvider, TimezoneProvider>();

        return services;
    }
}
