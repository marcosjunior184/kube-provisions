kubectl create secret generic media-server-ssh-key \
  --from-file=privateKey=~/.ssh/id_rsa \
  --namespace=default


On media service 
# Create directories
sudo mkdir -p /media/{tv,movies}
sudo chown -R mediauser:mediauser /media



if file outside.
kubectl create configmap file-transfer-script \
  --from-file=transfer-files.sh=./transfer-files.sh \
  --namespace=default