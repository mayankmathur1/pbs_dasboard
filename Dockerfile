FROM python:3.7.2-slim AS builder

ARG JFROG_USER
ARG JFROG_PASS
ENV JFROG_USER=${JFROG_USER}
ENV JFROG_PASS=${JFROG_PASS}

COPY ./ /usr/src/app
WORKDIR /usr/src/app
RUN pip install -r requires/development.txt -i https://${JFROG_USER}:${JFROG_PASS}@yapta.jfrog.io/yapta/api/pypi/pypi-yapta/simple
RUN python setup.py bdist_wheel

FROM python:3.7.2-slim

RUN adduser --disabled-password -u 1000 cts-user

ARG JFROG_USER
ARG JFROG_PASS
ENV JFROG_USER=${JFROG_USER}
ENV JFROG_PASS=${JFROG_PASS}

COPY --from=builder /usr/src/app/dist/service-*.whl /tmp
RUN pip install /tmp/service-*.whl -i https://${JFROG_USER}:${JFROG_PASS}@yapta.jfrog.io/yapta/api/pypi/pypi-yapta/simple && rm /tmp/*

ENV FLASK_APP=service
EXPOSE 8080

USER 1000
CMD NEW_RELIC_APP_NAME=${FLASK_ENV}.${FLASK_APP} newrelic-admin run-program gunicorn -w 4 -b 0.0.0.0:8080 "service:create_app()"
