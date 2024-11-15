FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ticket_sys_booking/ticket_sys_booking.csproj", "ticket_sys_booking/"]
RUN dotnet restore "ticket_sys_booking/ticket_sys_booking.csproj"
COPY . .
WORKDIR "/src/ticket_sys_booking"
RUN dotnet build "ticket_sys_booking.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ticket_sys_booking.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ticket_sys_booking.dll"]
