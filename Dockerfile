# App 1
FROM golang:1.20.4-buster as builder1

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app1

# App 2
FROM golang:1.20 as builder2

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app2

# App 3
FROM golang@sha256:685a22e459f9516f27d975c5cc6accc11223ee81fdfbbae60e39cc3b87357306 as builder3

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app3


# An old version of debian buster as a base
FROM debian:buster-20210208

COPY --from=builder1 /app1 /bin
COPY --from=builder2 /app2 /bin
COPY --from=builder3 /app3 /bin

CMD [ "/bin/app1" ]
