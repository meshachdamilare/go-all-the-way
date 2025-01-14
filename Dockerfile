FROM golang:1.19-alpine3.17 as builder

#Set the Current Working directory inside the container
WORKDIR /go-all-the-way

#Copy go mod and sum files
COPY go.mod ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code from the current directory to the working directory inside  the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Start a new stage from scratch
FROM alpine:3.17

WORKDIR /root/

# COop the Pre-built binary file from the previoud stage
COPY --from=builder /go-all-the-way/main .

# Expose port 8080 to the outside world
EXPOSE 8080

#Command to run the executable
CMD ["./main"]