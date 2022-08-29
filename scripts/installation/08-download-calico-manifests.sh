#!/bin/bash

set -eux

curl https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml > tigera-operator.yaml
curl https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml > custom-resources.yaml

sed -ri 's|^(\s*)(cidr\s*:\s*192.168.0.0\/16\s*$)|\1cidr: '$cidr'|' custom-resources.yaml