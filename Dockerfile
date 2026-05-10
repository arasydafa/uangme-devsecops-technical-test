# Stage 1: Build
FROM golang:1.26-alpine AS builder

WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod ./
RUN go mod download

# Copy source code
COPY . .

# Build with security flags
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o helloworld .

# Stage 2: Run (minimal image)
FROM alpine:3.19

# Security: run as non-root user
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/helloworld .

# Security: set proper permissions
RUN chown appuser:appgroup /app/helloworld && \
    chmod 550 /app/helloworld

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["./helloworld"]
