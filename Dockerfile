# syntax=docker/dockerfile:1.4
FROM golang:1.19-bullseye AS builder

COPY . /src/fk-validator
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /src/fk-validator
RUN go install protoc-gen-fk-validator

# When building a Docker image on a host that does not match linux/amd64 (such as an M1),
# go install will put the binary in $GOPATH/bin/$GOOS_$GOARCH/. The mv command copies
# the binary to /go/bin so subsequent steps do not fail when copying from the builder.
RUN mv /go/bin/linux_amd64/* /go/bin || true

FROM scratch
COPY --from=builder --link /etc/passwd /etc/passwd
COPY --from=builder /go/bin/ /
USER nobody
ENTRYPOINT [ "/protoc-gen-fk-validator" ]
