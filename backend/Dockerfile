FROM golang:1.26-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy && \
    CGO_ENABLED=0 GOOS=linux go build -o /out/involt-server ./cmd/server && \
    CGO_ENABLED=0 GOOS=linux go build -o /out/involt-seed ./cmd/seed_production

FROM alpine:3.20

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder /out/involt-server /app/involt-server
COPY --from=builder /out/involt-seed /app/involt-seed
COPY --from=builder /src/assets /app/assets

ENV PORT=8080
EXPOSE 8080

USER app

CMD ["/app/involt-server"]