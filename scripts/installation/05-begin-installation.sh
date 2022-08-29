#!/bin/bash

set -eux

sudo kubeadm init --pod-network-cidr=$cidr --upload-certs --control-plane-endpoint=$endpoint