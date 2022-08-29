# Install Kubernetes

#### Install required Binaries

Run the following commands, to install kubelet, kubeadm, kubectl and helm:

```bash
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl helm
sudo apt-mark hold kubelet kubeadm kubectl
```

Confirm the work by running `kubectl version --client && kubeadm version`

#### Disable Swap

Kubernetes requires the swap file to be disabled on linux.

```bash
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
```

#### Enable Kernel Modules

These changes are required for Kubernetes to run.

The "overlay" module is the Overlay File System which containers need to run.

[https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html](https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html)

The "br\_netfilter" module allows Kubernetes to use certain networking tooling for Linux.

The sysctl file change allows access to IPTables, which is the main way Kubernetes uses to control network traffic.

```bash
# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system
```

#### Install containerd

Containerd is what actually runs all the containers. The Kubelet will connect to containerd to start up new containers and manage them.

```bash
# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
sudo apt update
sudo apt install -y containerd.io

# Configure containerd and start service
sudo su -
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd
```

{% hint style="info" %}
Choose a DNS name for you cluster, in this case I will call it k8s.kubernetesdemo.com. You pick your own name and remember it going forward to use in various steps.
{% endhint %}

{% hint style="info" %}
Choose an IP address range for all the containers running in Kubernetes. My home network is 192.168.0.0/24, so I picked 10.0.0.0/16 so that the ranges do NOT overlap.
{% endhint %}

#### Add an A Record for your server's IP

My home server say is on 192.168.0.41, I created an A record for k8s.kubernetesdemo.com that points to 192.168.0.41.

#### Begin Kubernetes Installation

With the script below, replace the 10.0.0.0/16 with the IP address range you require, and replace the control-plane-endpoint with the domain name you chose.

```bash
sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --upload-certs --control-plane-endpoint=k8s.mydomain.com
```

#### Set up kubectl config file

Once kubeadm installation has finished it will create a configuration file that you can use to connect to the cluster. You will need this file:

```bash
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl cluster-info
```

#### Remove Node taints

Kuberentes by default is designed to run both "master" and "worker" nodes. The master nodes run the very important Kubernetes software, and the worker nodes run the various containers that you want to run.

In our case we only have the one server and by defualt Kubernetes will NOT allow you to run stuff on this node.

We can remove "node taints" which in essence allows use to run anything on our single node.

```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

#### Install Network Addon (Calico)

The one addon you MUST install for anything to work, is a network addon. There are a selection of addons that you can use, in this case we will install Calico.

Download their latest manifests:

```bash
curl https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml > tigera-operator.yaml
curl https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml > custom-resources.yaml
```

Edit custom-resources.yaml, and under spec -> calicoNetwork -> blocksize -> cidr, replace the value with the IP address range you chose above.

A sample of what I used:

```yaml
# This section includes base Calico installation configuration.
# For more information, see: https://projectcalico.docs.tigera.io/v3.23/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: 10.0.0.0/16
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()

---

# This section configures the Calico API server.
# For more information, see: https://projectcalico.docs.tigera.io/v3.23/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
  name: default
spec: {}

```

Now we can install both yaml manifests:

```bash
kubectl apply -f tigera-operator.yaml
kubectl apply -f custom-resources.yaml
```



