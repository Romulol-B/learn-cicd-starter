FROM golang:1.22-bookworm AS build

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -mod=vendor -o /out/notely .

FROM debian:stable-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /out/notely /usr/bin/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/usr/bin/notely"]
