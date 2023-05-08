FROM docker.io/alpine:latest

RUN apk add --no-cache \
        gcc \
        git \
        musl-dev \
        py3-pip \
        py3-setuptools \
        py3-wheel \
        python3 \
        python3-dev \
     && git clone https://github.com/graphite-project/whisper \
     && cd whisper \
     && GRAPHITE_NO_PREFIX=True python setup.py install \
     && cd .. \
     && git clone https://github.com/graphite-project/carbon \
     && cd carbon \
     && GRAPHITE_NO_PREFIX=True python setup.py install \
     && cd .. \
     && mkdir -p /etc/carbon \
     && cp /usr/lib/python*/site-packages/carbon-*.egg/conf/carbon.conf.example /etc/carbon/carbon.conf \
     && cp /usr/lib/python*/site-packages/carbon-*.egg/conf/storage-schemas.conf.example /etc/carbon/storage-schemas.conf \
     && cp /usr/lib/python*/site-packages/carbon-*.egg/conf/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf \
     && mkdir -p /var/lib/carbon

ENV GRAPHITE_STORAGE_DIR=/var/lib/carbon

CMD [ "/usr/bin/carbon-cache.py", "--nodaemon", "--config", "/etc/carbon/carbon.conf", "start" ]
