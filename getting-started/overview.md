# Overview

This page will describe what we will install and in what order, to give you a good picture of how it all fits together.

### Set up a base machine using Ubuntu 20.04

This involves setting up a ready to go linux machine that we can use to run everything.

### Install Kubernetes Prerequisites

This will involve installing a selection of binaries that we will use to install and manage Kubernetes with: kubelet, kubeadm, kubectl and helm.

#### Kubelet

This is a piece of software that runs on all the nodes in Kuberentes and it performs vital functions for Kubernetes.

[https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

#### Kubeadm

This is a tool that makes setting up, installing and upgrading Kubernetes a lot easier.

[https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

#### Kubectl

This is the main cli tool you use to interact with Kubernetes.

[https://kubernetes.io/docs/reference/kubectl/](https://kubernetes.io/docs/reference/kubectl/)

#### Helm

This tool allows you to package up and deploy collections of yaml. We will use it often to install other peoples packages.

[https://helm.sh/docs/](https://helm.sh/docs/)

### Install Containerd

Containerd is the actual system that runs the containers. Many people use Docker when running on their desktop, but in many modern production systems, people use containerd.

[https://containerd.io/](https://containerd.io/)

### Install Kubernetes

Using kubeadm, we will install and setup Kubernetes.

We will also install a necessary network add-on, which is required to allow all the various containers to connect via the network. In this case we will install Calico.

[https://projectcalico.docs.tigera.io/getting-started/kubernetes/](https://projectcalico.docs.tigera.io/getting-started/kubernetes/)

### Install ArgoCD

ArgoCD will allow use to start using a git repostory to build up the rest of the cluster. This will be installed and from this point forward, we can use a git repository to do the rest instead of SSHing on to the server.

&#x20;[https://argo-cd.readthedocs.io/en/stable/](https://argo-cd.readthedocs.io/en/stable/)

### Install Cluster Addons

Using ArgoCD and a git repository, we will start to install various cluster addons to see how they might work.



