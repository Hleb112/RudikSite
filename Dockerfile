# 1. Сборка
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Копируем go.mod
COPY go.mod ./
RUN go mod download

# Копируем весь проект
COPY . .

# Собираем бинарник
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# 2. Минимальный рантайм
FROM alpine:latest

WORKDIR /app

# Копируем бинарник и нужные папки
COPY --from=builder /app/app .
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static

# Back4App / PaaS использует PORT
EXPOSE 8080

CMD ["./app"]
