FROM alpine:3.10

RUN apk add --update --no-cache build-base wget git curl && \
    wget https://github.com/nxadm/rakudo-pkg/releases/download/v2019.07.1-03/rakudo-pkg-Alpine3.10_2019.07.1-03_x86_64.apk && \
    apk add --allow-untrusted rakudo-pkg-Alpine3.10_2019.07-03_x86_64.apk

ENV PATH=$PATH:/opt/rakudo-pkg/bin
