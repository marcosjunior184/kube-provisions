# Create passwords

read -s <pwd_variable>
kubectl -n <namespace> create secret generic mongo-password --from-literal key="$<pwd_variable>"

set -a
source .env
set a+
envsubst < 03.secrets.yaml | kubectl apply -f -

kubectl -n cloud create configmap collabora-config --from-file=coolwsd.xml
