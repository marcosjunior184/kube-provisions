# Seal secret controller
## Install the controller
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml

## Install CLI client
curl -OL "https://github.com/bitnami/sealed-secrets/releases/download/v0.38.1/kubeseal-0.38.1-linux-amd64.tar.gz"
tar -xvzf kubeseal-0.38.1-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

-- Check releases at https://github.com/bitnami/sealed-secrets/releases


# Usage
kubeseal --format yaml < [file.with.base.64.encoded.secret.yml] > [encripted.file.seal.yml]

example

kubeseal --format yaml < 01.myapp-secret.yml > 01.myapp-secret-sealed.yml 