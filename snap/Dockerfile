FROM ubuntu:16.04
MAINTAINER Nan Liu <nan.liu@gmail.com>

ARG BUILD_DATE
ARG SNAP_VERSION=latest

ENV SNAP_VERSION=${SNAP_VERSION}
ENV SNAP_TRUST_LEVEL=0
ENV SNAP_LOG_LEVEL=1
ENV CI_URL=https://s3-us-west-2.amazonaws.com/snap.ci.snap-telemetry.io
ENV SNAP_URL="http://127.0.0.1:8181"

LABEL vendor="Intelsdi-X" \
      name="Snap Alpine 3.4" \
      license="Apache 2.0" \
      build-date=$BUILD_DATE \
      io.snap-telemetry.snap.version=$SNAP_VERSION \
      io.snap-telemetry.snap.version.is-beta=

EXPOSE 8181

ADD ${CI_URL}/snap/${SNAP_VERSION}/linux/x86_64/snapteld  /opt/snap/sbin/snapteld
ADD ${CI_URL}/snap/${SNAP_VERSION}/linux/x86_64/snaptel  /opt/snap/bin/snaptel
COPY init_snap /usr/local/bin/init_snap
COPY snapteld.conf /etc/snap/snapteld.conf

CMD /usr/local/bin/init_snap && /opt/snap/sbin/snapteld -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''
