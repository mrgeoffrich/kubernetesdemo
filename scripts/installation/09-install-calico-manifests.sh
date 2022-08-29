#!/bin/bash

set -eux

kubectl apply -f tigera-operator.yaml
kubectl apply -f custom-resources.yaml