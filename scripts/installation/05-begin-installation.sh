#!/bin/bash

set -eux

if [ -z ${cidr+x} ]; then echo "variable cidr is unset"; exit 1; fi
if [ -z ${endpoint+x} ]; then echo "variable endpoint is unset"; exit 1; fi

sudo kubeadm init --pod-network-cidr=$cidr --upload-certs --control-plane-endpoint=$endpoint