FROM golang:1.22-alpine

RUN apk update
RUN apk add --no-cache ffmpeg ffmpegthumbnailer

RUN go install github.com/cosmtrek/air@latest

ENTRYPOINT ["/go/bin/air"]
