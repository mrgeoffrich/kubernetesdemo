# Cluster Addons & Tools

## What are cluster add-ons?

Building a useful Kubernetes cluster involves installing a selection of software into that cluster once it is up and running. There is a massive variety of add-ons that can automate a whole selection of tasks.

Installation and configuration of these tools will take up most of your time during this tutorial.

The tools we will install are as follows:

#### TLS Certificate Management

We will install cert-manager, whose job is to create and manage/renew TLS certificates to allow you to serve traffic over https.

Cert-Manager: [https://cert-manager.io/docs/installation/](https://cert-manager.io/docs/installation/)

#### DNS Automation

We will install external-dns, whose job is to automate the creation of DNS records for your websites. This tool will create DNS records and configure them to point to the correct IP address for you.

External-dns: [https://github.com/kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)

#### Ingress Controller

Ingress is a mechanism inside Kubernetes that lets you use a web server, in this case nginx, to route traffic and provide TLS offloading into you hosted applications. We will be installing the nginx ingress controller.

Nginx Ingress Controller: [https://docs.nginx.com/nginx-ingress-controller/](https://docs.nginx.com/nginx-ingress-controller/)

#### Load Balancer (for Bare Metal)

When exposing services in Kubernetes, you can create a "LoadBalancer" service. When you do this on a cloud platform like AWS, Azure or GCP, it will create a new public IP address and a load balancer to route traffic from the general internet into that service.

When running on a home lab you don't have access to these services, but there is a great tool called MetalLB, which will grab an IP address from you home network and route traffic through it, achieving the desired outcome.

MetalLB: [https://metallb.universe.tf/](https://metallb.universe.tf/)

#### GitOps Tooling

When we build this cluster, one of the first tools we are going to installed in ArgoCD. ArgoCD allows you to use a git repository to configure and manage whats running in the cluster.

Learning to use one of these tools is super useful, but also it lets us build up the cluster in a much easier fashion.

ArgoCD: [https://argo-cd.readthedocs.io/en/stable/](https://argo-cd.readthedocs.io/en/stable/)

#### Storage

In Kubernetes, managing storage is a bit different to other systems. When running in a cloud platform like Azure, AWS or GCP, they provide addons (CSI drivers) which will go and create managed disks for you and will then attach them to the underlying machine.

When running in a home lab you will need to use a slightly different approach as you will just want to use the local disk on your server to store files on.

A great tool that does exactly this is called OpenEBS.

OpenEBS: [https://openebs.io/docs](https://openebs.io/docs)

#### Monitoring

For all clusters, setting up a robust monitoring solution is a must. In this case we will look at setting up Prometheus and Grafana, and ensuring it can monitor all our services with a set of useful dashboards.

Prometheus: [https://prometheus.io/docs/introduction/overview/](https://prometheus.io/docs/introduction/overview/)

Grafana: [https://grafana.com/docs/](https://grafana.com/docs/)
