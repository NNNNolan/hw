## 修改内容

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

WORKDIR /src
COPY ["src/HW/HW.csproj", "src/HW/"]
RUN dotnet restore "src/HW/HW.csproj"

COPY . .
WORKDIR "/src/src/HW"
RUN dotnet publish -c Release  --use-current-runtime -o /usr/release -p:PublishSingleFile=true -p:PublishTrimmed=true
FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.0-alpine3.16

WORKDIR /app
COPY --from=build /usr/release /app
RUN apk add --no-cache tzdata
RUN chmod 777 /app/*
ENV TZ=Asia/Shanghai
CMD ["/app/HW"]