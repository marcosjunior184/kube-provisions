RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (reset)
CONFIG_FILE="./k3s.conf"

# echo "=== Creating TLS ==="

logger(){
	color=$1
	msg=$2

	echo -e ${color}${msg}${NC}
}

set_config(){
	logger $BLUE "STEP => Set Up Config File"
	if [ -f "$CONFIG_FILE" ]; then
		source "$CONFIG_FILE"
		logger $GREEN "... Config File Set"
	else
		logger $RED "Config file not found!"
		exit 1
	fi
}

backup(){

	logger $BLUE "STEP => Initializing Back Up"

	mkdir -p "$BACKUP_DIR"

	backup_files=("./local.crt" "./local.key")

	for file in "${backup_files[@]}"; do

		if [[ -f "$file" ]]; then
			back_file_date=$(date +"%Y-%m-%d")
			cp "$file" "$BACKUP_DIR/${back_file_date}_${file:2}"
			rm -rf "$file"
		fi
	done
}

k3s_load_certs(){
	logger $BLUE "STEP => Loading Secrets on Namespaces"

	for ns in "${TLS_SECRETS[@]}"; do

		if kubectl -n $ns get secrets local-tls &>/dev/null; then
			kubectl -n $ns delete secrets $TLS_NAME
		fi
		kubectl -n $ns create secret tls $TLS_NAME --cert=local.crt --key=local.key
	done
}

logger "=== Creating TLS ==="

set_config
mkdir -p "$CERTS_DIR"
cd "$CERTS_DIR"
backup

logger $BLUE "STEP => Start Certs Creation"
# Create CA private Key
openssl genrsa -out ca.key 2048
logger ... created ca.key 
# Self Sign CA cert
openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/CN=HomeLab CA"
logger ... created ca.crt

# Create server private Key
openssl genrsa -out local.key 2048
logger ... created local.key
# Create Sign request
openssl req -new -key local.key -out local.csr -config san.conf
logger ... created local.csr
# Create signed cert
openssl x509 -req -in local.csr -CA ca.crt -CAkey ca.key -out local.crt -days 365 -CAcreateserial -extensions v3_req -extfile san.conf
logger ... created local.crt

logger ... cleaning
rm -f local.csr ca.crt ca.key cas.srl

# Create signed cert
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509   -keyout local.key -out local.crt -config san.conf

k3s_load_certs





# # kubectl -n kube-system create secret tls local-tls --cert=local.crt --key=local.key

# echo "Loading secrets on namespaces"
# for ns in "${TLS_SECRETS[@]}"; do
#     echo "  - $ns"

# 	if kubectl -n $ns get secrets local-tls &>/dev/null; then
# 		kubectl -n $ns delete secrets $TLS_NAME
# 	fi
# 	kubectl -n $ns create secret tls $TLS_NAME --cert=local.crt --key=local.key
# done


# usage(){
# 	echo "Usage"
# }

# while getopts "un:" opt; do
# 	case $opt in
# 		u) usage= usage ;;
# 		n) namespace=$OPTARG ;;
# 		\?) exit 1 ;;
# 	esac
# done


# for file in *.yaml; do
#         echo ... applying $file

#         #kubectl apply -f $file

#         echo -e "\n"
# done