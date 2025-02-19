# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

# ==============================================================================
# Build process
# ------------------------------------------------------------------------------
FROM python:3.13.1-alpine3.21 as build
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin"

WORKDIR /app/
COPY app /app/

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache libxslt libxml2 libffi-dev build-base

# hadolint ignore=DL3013
RUN pip3 install --user --no-cache-dir --only-binary :all: \
        --find-links https://wheels.home-assistant.io/musllinux/ \
        cryptography lxml ;\
    pip3 install --user --no-cache-dir --prefer-binary \
        --find-links https://wheels.home-assistant.io/musllinux/ \
	-r requirements.txt

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM python:3.13.1-alpine3.21

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache git libffi libxml2 libxslt

ENV PATH "$PATH:/app/bin"
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
    org.label-schema.usage="https://gitlab.com/pipeline-components/ansible-lint/blob/main/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/ansible-lint/" \
    org.label-schema.vendor="Pipeline Components"
