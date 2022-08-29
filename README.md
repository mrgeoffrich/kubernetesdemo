---
description: What this tutorial will take you through
---

# Getting Started

This is an opinionated set of installation scripts to assist with setting up a cluster for running on a single node in a home-lab style environment.

The important goal of this tutorial is to not just set up an empty Kubernetes cluster, but to also install a recommended set of cluster add-ons and tools to make the cluster useful for running workloads. These tools are quite similar to what I use to run my production clusters with, with some variation due to the fact that this is a home lab machine.

This will include installing:

* DNS Integration
* An Ingress controller
* TLS Certificate Provisioning
* Storage Management
* GitOps tooling
* Load Balancer support for a bare metal machine
* Monitoring

I will also attempt to explain and describe each step, with links to deep dive for more information. This guide will cover a lot, but not all in great depth. It should get you a useful environment up and running to get started from.

To keep the installation steps simple there will be very minimal variation in what's installed. The initial example will required an Azure account with a DNS zone set up in there. Future support for AWS will come.
