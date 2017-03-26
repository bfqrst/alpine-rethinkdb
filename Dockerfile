FROM armhf/alpine:edge
MAINTAINER Ralph Stoichita <rst@binaryFABRIQ.com>

# This is the release and arch of RethinkDB to pull in.
ENV RETHINKDB_VERSION=2.3.5
# ENV RETHINKDB_ARCH=arm

# Create a RethinkDB user and group first so the IDs get set the same way,
# even as the rest of this may change over time.
RUN addgroup rethinkdb && \
    adduser -S -G rethinkdb rethinkdb

RUN set -ex && apk --no-cache update && apk --no-cache upgrade && \
               apk add --no-cache --virtual .rethinkdb-runtime-deps su-exec tini build-base musl-dev bash \
                                            linux-headers libffi-dev openssl-dev git protobuf-c-dev protobuf-dev boost-dev wget m4 curl

RUN cd /tmp && wget https://download.rethinkdb.com/dist/rethinkdb-2.3.5.tgz && tar xf rethinkdb-2.3.5.tgz && cd rethinkdb-2.3.5 && ./configure --with-system-malloc --all$

#   process cluster webui
EXPOSE 28015 29015 8080

ENTRYPOINT ["/sbin/tini", "--", "rethinkdb"]
