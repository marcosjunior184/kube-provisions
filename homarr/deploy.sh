set -a
source .env
set a+
envsubst < 02.secret.yaml | kubectl apply -f -