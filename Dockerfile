# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

# ==============================================================================
# Build process
# ------------------------------------------------------------------------------
FROM python:3.9.5-alpine3.13 as build
ENV PYTHONUSERBASE /app

WORKDIR /app/
COPY app /app/

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache libxslt

# sub dependencies preinstalling from home-assistant
# hadolint ignore=DL3013
RUN pip3 install --user --no-cache-dir --only-binary :all: --find-links https://wheels.home-assistant.io/alpine-3.13/amd64/ cryptography lxml

RUN pip3 install --user --no-cache-dir -r requirements.txt

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM python:3.9.5-alpine3.13

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache git libffi libxml2 libxslt

ENV PATH "$PATH:/app/bin/"
ENV PYTHONUSERBASE /app
COPY --from=build /app /app

# ==============================================================================
# Generic for all components
# ------------------------------------------------------------------------------
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD ansible-lint

WORKDIR /code/

# ==============================================================================
# Container meta information
# ------------------------------------------------------------------------------
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Ansible-lint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Ansible-lint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/ansible-lint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/ansible-lint/" \
    org.label-schema.vendor="Pipeline Components"
