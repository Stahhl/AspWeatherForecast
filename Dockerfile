FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["AspWeatherForecast/AspWeatherForecast.csproj", "AspWeatherForecast/"]
RUN dotnet restore "AspWeatherForecast/AspWeatherForecast.csproj"
COPY . .
WORKDIR "/src/AspWeatherForecast"
RUN dotnet build "AspWeatherForecast.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspWeatherForecast.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspWeatherForecast.dll"]
