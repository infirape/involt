FROM golang:1.26-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o /out/involt-server ./cmd/server

FROM alpine:3.20

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder /out/involt-server /app/involt-server
COPY cmd/admin/templates /app/cmd/admin/templates

ENV PORT=8080
EXPOSE 8080

USER app

CMD ["/app/involt-server"]