using Mapster;
using Overstay.Application.Features.Notifications.Commands;
using Overstay.Application.Features.Users.Commands;
using Overstay.Application.Features.Visas.Commands;
using Overstay.Application.Features.Visas.Requests;
using Overstay.Application.Features.VisaTypes.Commands;
using Overstay.Domain.Entities;

namespace Overstay.Application.Commons.Configurations;

public static class MappingConfigurations
{
    public static void Configure()
    {
        TypeAdapterConfig.GlobalSettings.Default.IgnoreNullValues(true);

        TypeAdapterConfig<UpdateVisaTypeCommand, VisaType>
            .NewConfig()
            .IgnoreNullValues(true)
            .Map(dest => dest.Id, src => src.Id)
            .Map(dest => dest, src => src.Item);

        TypeAdapterConfig<CreateVisaCommand, Visa>
            .NewConfig()
            .IgnoreNullValues(true)
            .ConstructUsing(src => new Visa(src.Item.ArrivalDate, src.Item.ExpireDate))
            .Map(dest => dest.VisaTypeId, src => src.Item.VisaTypeId)
            .Map(dest => dest.UserId, src => src.UserId);

        TypeAdapterConfig<UpdateVisaCommand, Visa>
            .NewConfig()
            .IgnoreNullValues(true)
            .ConstructUsing(src => new Visa(src.Item.ArrivalDate, src.Item.ExpireDate))
            .Map(dest => dest.VisaTypeId, src => src.Item.VisaTypeId)
            .Map(dest => dest.Id, src => src.Id);
    }
}
