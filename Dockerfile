# App 1
FROM golang:1.20.5-buster as builder1

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app1

# App 2
FROM golang:1.22.0 as builder2

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app2

# App 3
FROM golang@sha256:ef61a20960397f4d44b0e729298bf02327ca94f1519239ddc6d91689615b1367 as builder3

WORKDIR /

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY ./*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app3


# Random images to test out
FROM gcr.io/distroless/static

COPY --from=builder1 /app1 /bin
COPY --from=builder2 /app2 /bin
COPY --from=builder3 /app3 /bin

CMD [ "/bin/app1" ]
