FROM golang:1.23-alpine AS builder

WORKDIR /src/backend

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ ./
RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o /out/involt-server ./cmd/server

FROM alpine:3.20

WORKDIR /app/backend

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder /out/involt-server /app/backend/involt-server
COPY backend/cmd/admin/templates /app/backend/cmd/admin/templates
COPY assets /app/assets

ENV PORT=8080
EXPOSE 8080

USER app

CMD ["/app/backend/involt-server"]
