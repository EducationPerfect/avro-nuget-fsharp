FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

COPY entrypoint.sh .
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh"]
