echo Start creating Certs
# Create CA private Key
openssl genrsa -out ca.key 2048
echo ... created ca.key 
# Self Sign CA cert
openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/CN=HomeLab CA"
echo ... created ca.crt

# Create server private Key
openssl genrsa -out local.key 2048
echo ... created local.key
# Create Sign request
openssl req -new -key local.key -out local.csr -config san.conf
echo ... created local.csr
# Create signed cert
openssl x509 -req -in local.csr -CA ca.crt -CAkey ca.key -out local.crt -days 365 -CAcreateserial -extensions v3_req -extfile san.conf
echo ... created local.crt

echo ... cleaning
rm -f local.csr


echo ... Loading cert to k3s

if kubectl -n proxy get secrets local-tls &>/dev/null; then
	kubectl -n proxy delete secrets local-tls
fi

# Create signed cert
#openssl req -new -newkey rsa:2048 -days 365 -nodes -x509   -keyout local.key -out local.crt -config san.conf

kubectl -n proxy create secret tls local-tls --cert=local.crt --key=local.key
