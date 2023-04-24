FROM golang:1.19-alpine3.17 AS base

RUN apk add --no-cache git

WORKDIR /tmp/pod-info

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o ./out/pod-info .


FROM alpine:3.17

RUN apk add ca-certificates

COPY --from=base /tmp/pod-info/out/pod-info /app/pod-info
COPY --from=base /tmp/pod-info/main.html /app/main.html

EXPOSE 8080

ENTRYPOINT [ "/app/pod-info" ]