## 修改内容

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

WORKDIR /src
COPY ["src/HW/HW.csproj", "src/HW/"]
RUN dotnet restore "src/HW/HW.csproj"

COPY . .
WORKDIR "/src/src/HW"
ARG RID=linux-musl-x64
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ];  then \
     RID=linux-x64 ; \
elif [ "§TARGETPLATFORM" = "linux/arm64" ]; then \
     RID=linux-musl-arm64；\
elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
     RID=linux-musl-arm ;\
fi && \
RUN dotnet publish -c Release  RID -o /app -p:PublishSingleFile=true -p:PublishTrimmed=true
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.0-alpine3.16

WORKDIR /app
COPY --from=build /app .
RUN apk add --no-cache tzdata
RUN chmod 777 /app/*
ENV TZ=Asia/Shanghai
ENTRYPOINT ["./HW"]
