FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["NetCoreRestAPI.csproj", "./"]
RUN dotnet restore "./NetCoreRestAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NetCoreRestAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NetCoreRestAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NetCoreRestAPI.dll"]
