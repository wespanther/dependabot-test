# App 1
FROM golang:1.20.5-buster as builder1

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app1

# App 2
FROM golang:1.20.5 as builder2

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app2

# App 3
FROM golang@sha256:9d0422f7dc934f665111a8545e0531705efc9c7df8c34dd173f8ae5d80565d37 as builder3

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app3


# A random to test out
FROM gcr.io/cloud-marketplace/google/rbe-ubuntu18-04 
FROM golang:1.20 as builder1
FROM golang:1.20.1 as builder2
FROM golang:latest as builder3
FROM gcr.io/distroless/static
FROM gcr.io/distroless/static:latest
FROM gcr.io/google-containers/pause:3.2

COPY --from=builder1 /app1 /bin
COPY --from=builder2 /app2 /bin
COPY --from=builder3 /app3 /bin

CMD [ "/bin/app1" ]
