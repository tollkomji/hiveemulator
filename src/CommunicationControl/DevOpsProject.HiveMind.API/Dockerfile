FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY DevOpsProject.sln ./
COPY DevOpsProject.HiveMind.API/DevOpsProject.HiveMind.API.csproj DevOpsProject.HiveMind.API/
COPY DevOpsProject.HiveMind.Logic/DevOpsProject.HiveMind.Logic.csproj DevOpsProject.HiveMind.Logic/
COPY DevOpsProject.Shared/DevOpsProject.Shared.csproj DevOpsProject.Shared/

RUN dotnet restore DevOpsProject.HiveMind.API/DevOpsProject.HiveMind.API.csproj

COPY . .
RUN dotnet publish DevOpsProject.HiveMind.API/DevOpsProject.HiveMind.API.csproj \
    --configuration Release \
    --output /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

COPY --from=build --chown=appuser:appuser /app/publish ./

USER appuser

EXPOSE 5149

ENTRYPOINT ["dotnet", "DevOpsProject.HiveMind.API.dll"]
