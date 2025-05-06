FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["Overstay-api.sln", "."]
COPY ["src/Overstay.API/Overstay.API.csproj", "src/Overstay.API/"]
COPY ["src/Overstay.Application/Overstay.Application.csproj", "src/Overstay.Application/"]
COPY ["src/Overstay.Domain/Overstay.Domain.csproj", "src/Overstay.Domain/"]
COPY ["src/Overstay.Infrastructure/Overstay.Infrastructure.csproj", "src/Overstay.Infrastructure/"]
COPY ["test/Overstay.IntegrationTest/Overstay.IntegrationTest.csproj", "test/Overstay.IntegrationTest/"]
COPY ["test/Overstay.UnitTest/Overstay.UnitTest.csproj", "test/Overstay.UnitTest/"]
RUN dotnet restore
COPY . .
WORKDIR "/src/src/Overstay.API"
RUN dotnet build "Overstay.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Overstay.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Overstay.API.dll"]