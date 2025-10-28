# CloudFlare set up

1. Install CloudFlare Tunnel
```bash
# Download cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin/
```

2. Authenticate Cloudflare tunner 
```bash
cloudflared tunnel login
```

3. Create Tunnel
```bash
cloudflared tunnel create react-app-tunnel
```


# Get Cloudflare tunnel credentials
```bash
# List your tunnels to get the ID
cloudflared tunnel list

# Get the credentials file path
cloudflared tunnel info YOUR_TUNNEL_ID

# Base64 encode the credentials file for Kubernetes secret
cat /path/to/credentials.json | base64 -w 0
```


# For testing

ingress:
  - hostname: your-app.trycloudflare.com    # Free Cloudflare subdomain
    service: http://react-app-service:80
  - service: http_status:404


# Testing on same network

kubectl port-forward --address 0.0.0.0 service/react-app-service 8080:80