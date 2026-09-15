FROM docker.io/gitea/act_runner:latest

# Tools we actually need:
#   skopeo  -> registry-to-registry copy (supports --all for multi-arch)
#   crane   -> digest checks, manifest inspection, scriptable output
#   trivy   -> vulnerability scan
#   jq/yq   -> parse JSON / edit manifests
#   git     -> commit GitOps changes
RUN apk add --no-cache \
      skopeo \
      curl \
      bash \
      git \
      jq \
      yq

# crane (static Go binary)
ARG CRANE_VERSION=v0.20.2
RUN curl -sfL "https://github.com/google/go-containerregistry/releases/download/${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz" \
      | tar -xz -C /usr/local/bin crane \
 && chmod +x /usr/local/bin/crane

# trivy (official install script)
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
      | sh -s -- -b /usr/local/bin

# smoke test
RUN skopeo --version && crane version && trivy --version