
FROM golang:1.19.1-buster as builder1
FROM golang:1.19 as builder2

FROM gcr.io/distroless/static@sha256:7198a357ff3a8ef750b041324873960cf2153c11cc50abb9d8d5f8bb089f6b4e

COPY --from builder1 /usr/local/go/bin/go /bin/go1
COPY --from builder2 /usr/local/go/bin/go /bin/go2


