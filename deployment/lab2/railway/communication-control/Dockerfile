FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/CommunicationControl/DevOpsProject.sln ./
COPY src/CommunicationControl/DevOpsProject/DevOpsProject.CommunicationControl.API.csproj DevOpsProject/
COPY src/CommunicationControl/DevOpsProject.CommunicationControl.Logic/DevOpsProject.CommunicationControl.Logic.csproj DevOpsProject.CommunicationControl.Logic/
COPY src/CommunicationControl/DevOpsProject.Shared/DevOpsProject.Shared.csproj DevOpsProject.Shared/

RUN dotnet restore DevOpsProject/DevOpsProject.CommunicationControl.API.csproj

COPY src/CommunicationControl/ ./
RUN dotnet publish DevOpsProject/DevOpsProject.CommunicationControl.API.csproj \
    --configuration Release \
    --output /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

COPY --from=build --chown=appuser:appuser /app/publish ./

USER appuser

EXPOSE 8080

CMD Urls="http://0.0.0.0:${PORT:-8080}" dotnet DevOpsProject.CommunicationControl.API.dll
