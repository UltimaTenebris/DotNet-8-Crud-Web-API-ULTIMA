# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copy the csproj from the correct folder
COPY ["DotNetCrudWebApi/DotNetCrudWebApi.csproj", "DotNetCrudWebApi/"]

# 2. Restore dependencies
RUN dotnet restore "DotNetCrudWebApi/DotNetCrudWebApi.csproj"

# 3. Copy everything else
COPY . .

# 4. Build inside the correct folder
WORKDIR "/src/DotNetCrudWebApi"
RUN dotnet build "DotNetCrudWebApi.csproj" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish "DotNetCrudWebApi.csproj" -c Release -o /app/publish

# Stage 3: Final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetCrudWebApi.dll"]

