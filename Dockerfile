FROM alpine:3.6

LABEL maintainer "mbroome@sharecare.com"

COPY aws-es-proxy /aws-es-proxy
RUN echo \
  apk update && \
  apk add --no-cache curl ca-certificates

EXPOSE 9200
ENTRYPOINT ["/aws-es-proxy"]
CMD ["/aws-es-proxy"]
#CMD ["/usr/bin/tail", "-f /dev/null"]

