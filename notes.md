# Notes



**Install metalLB**

Chose an IP range from your home lab network that you can use that nothing else is using, I used 192.168.0.210-192.168.0.230

Create the following files:

metallb-address-pool.yaml

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.0.210-192.168.0.230
```

Note: ensure that IP range in metallb-address-pool.yaml is correct for your homelab network.

metallb-l2-advert.yaml

```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: main-advert
  namespace: metallb-system
```

```bash
curl https://raw.githubusercontent.com/metallb/metallb/v0.13.3/config/manifests/metallb-native.yaml > metallb-native.yaml
kubectl apply -f metallb-native.yaml
kubectl apply -f metallb-address-pool.yaml
kubectl apply -f metallb-l2-advert.yaml
```

**Install Nginx Ingress**

```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginxingress nginx-stable/nginx-ingress
```

You should now see nginx ingress with a load balancer IP from that range avaiable. Broswing to that IP on port 80 should return a 404 page from nginx.

**Install Argo CD**

```bash
curl https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > argo-install.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f argo-install.yaml
```

**Expose ArgoCD via a Load Balancer**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: argocd-server-external
  namespace: argocd
annotations:
  external-dns.alpha.kubernetes.io/hostname=argocd.kubernetesdemo.com
spec:
  ports:
    - name: https
      protocol: TCP
      port: 443
      targetPort: 8080
  selector:
    app.kubernetes.io/name: argocd-server
  type: LoadBalancer
```

## Prometheus

### Patch etcd.yaml ->

change `- --listen-metrics-urls=http://127.0.0.1:2381,http://192.168.0.40:2381`

### Change etcd service ->

kube-prometheus-stack-kube-etcd service needs a different port

```yaml
  ports:
    - name: http-metrics
      protocol: TCP
      port: 2381
      targetPort: 2381
```

### Patch kube-controller-manager.yaml

change `- --bind-address=0.0.0.0`

### Patch kube-scheduler.yaml

change `- --bind-address=0.0.0.0`

### Kube proxy

Change kube-proxy config map, config.conf, metricsBindAddress set to 0.0.0.0.

### Fix kube-state-metrics service discovery

Modify the ServiceMonitor kube-prometheus-stack-kube-state-metrics to look like:

```yaml
spec:
  endpoints:
    - honorLabels: true
      port: http
  jobLabel: app.kubernetes.io/name
  selector:
    matchLabels:
      release: kube-prometheus-stack
      app.kubernetes.io/name: kube-state-metrics
```

### Fix configuration bug on kube prometheus stack

From the ServiceMonitor kube-prometheus-stack-kubelet remove the following rule:

Remove:

```yaml
        - action: drop
          regex: .+;
          sourceLabels:
            - id
            - container
```

This fixed an issue where the network stats dont appear since they never have the container label set.
