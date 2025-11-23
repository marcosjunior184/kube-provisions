kubectl create secret tls myapp-tls --cert=myapp.local.crt --key=myapp.local.ke

then add

 tls:
    secretName: myapp-tls  # Use your custom certificate


or


myapp.local {
    tls internal
    reverse_proxy myapp-service:80
}

www.myapp.local {
    tls internal
    reverse_proxy myapp-service:80
}

admin.myapp.local {
    tls internal
    reverse_proxy myapp-service:80
}




apiVersion: v1
kind: ConfigMap
metadata:
  name: caddy-config
data:
  Caddyfile: |
    # Caddy will auto-generate and manage TLS certificates
    myapp.local, www.myapp.local, admin.myapp.local {
        tls internal
        reverse_proxy myapp-service:80
        
        # Optional: Enable logging
        log {
            output file /var/log/caddy/access.log
        }
    }




apiVersion: apps/v1
kind: Deployment
metadata:
  name: caddy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: caddy
  template:
    metadata:
      labels:
        app: caddy
    spec:
      containers:
      - name: caddy
        image: caddy:2-alpine
        ports:
        - containerPort: 80
        - containerPort: 443
        volumeMounts:
        - name: caddy-config
          mountPath: /etc/caddy
        - name: caddy-data
          mountPath: /data
        - name: caddy-logs
          mountPath: /var/log/caddy
      volumes:
      - name: caddy-config
        configMap:
          name: caddy-config
      - name: caddy-data
        emptyDir: {}  # Caddy stores certificates here
      - name: caddy-logs
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: caddy-service
spec:
  selector:
    app: caddy
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443




apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: caddy-ingress
spec:
  entryPoints:
    - web          # HTTP → redirect to HTTPS
    - websecure    # HTTPS → Caddy
  routes:
  - match: Host(`myapp.local`, `www.myapp.local`, `admin.myapp.local`)
    kind: Rule
    services:
    - name: caddy-service
      port: 443    # Connect to Caddy's HTTPS
  # No TLS section - Caddy handles certificates internally




# If you want persistent certificate storage
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: caddy-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
