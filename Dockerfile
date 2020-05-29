FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM alpine:3.12.0
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD ansible-lint


WORKDIR /app/

# Generic
COPY app /app/

# Python
RUN apk add --no-cache python3=3.8.2-r0 py3-paramiko=2.7.1-r0 py3-cryptography=2.8-r1

RUN pip3 install --no-cache-dir -r requirements.txt

ENV PATH "${PATH}:/app/bin/"

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Ansible-lint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Ansible-lint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/ansible-lint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/ansible-lint/" \
    org.label-schema.vendor="Pipeline Components"
