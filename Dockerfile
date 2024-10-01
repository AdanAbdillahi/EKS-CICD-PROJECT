# Use an official Golang image to create the build artifact
FROM golang:1.22.5 AS base

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod file and download dependencies
COPY go.mod ./

RUN go mod download

# Copy the source code from the current directory to the container's working directory
COPY . .

# Build the Go app targeting Linux amd64 to ensure compatibility
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Use a minimal base image to package the built binary
FROM gcr.io/distroless/base

# Set the Current Working Directory inside the container
WORKDIR /root

# Copy the Pre-built binary and static files from the builder stage
COPY --from=base /app/main .
COPY --from=base /app/static ./static

# Expose port 8080
EXPOSE 8080

# Command to run the executable
CMD ["./main"]
