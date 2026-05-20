# Image legacy alignée avec l'application fournie dans le TP.
# En contexte production réel, une migration vers une version .NET supportée serait prioritaire.
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base

LABEL org.opencontainers.image.source="https://github.com/bart120/m2cloud" \
      org.opencontainers.image.title="M2Cloud DotNetGigs" \
      org.opencontainers.image.description="Containerized service for the M2Cloud Kubernetes project"

WORKDIR /app
ENV ASPNETCORE_URLS=http://+:80 \
    DOTNET_RUNNING_IN_CONTAINER=true
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY . .
RUN dotnet restore "Services/Applicants.Api/applicants.api.csproj"
WORKDIR "/src/Services/Applicants.Api"
RUN dotnet publish "applicants.api.csproj" -c Release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "applicants.api.dll"]
