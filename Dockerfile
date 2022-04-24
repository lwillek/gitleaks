FROM golang:1.18 AS build
WORKDIR /go/src/github.com/lwillek/gitleaks
COPY . .
RUN VERSION=$(git describe --tags --abbrev=0) && \
CGO_ENABLED=0 go build -o bin/gitleaks -ldflags "-X="github.com/zricethezav/gitleaks/v8/cmd.Version=${VERSION}

FROM alpine:3.15.4
RUN addgroup --gid 1999 gitleaks && \
    adduser --disabled-password --uid 1999 --ingroup gitleaks gitleaks && \
    apk add --no-cache bash git openssh-client
COPY --from=build /go/src/github.com/lwillek/gitleaks/bin/* /usr/bin/
USER gitleaks:gitleaks

# TODO waiting to push this until I've thought a bit more about it
RUN git config --global --add safe.directory '*'

ENTRYPOINT ["gitleaks"]
