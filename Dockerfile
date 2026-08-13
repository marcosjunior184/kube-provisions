FROM alpine:latest

# Only install what's actually needed
RUN apk add --no-cache \
    buildah \
    curl \
    bash

# Install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Verify installations
RUN buildah --version && trivy --version