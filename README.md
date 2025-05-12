# FaasFlows-Demo-Config

This repository contains the configuration files needed to implement FaasFlows on the OpenFaaS platform. FaasFlows is an approach for reducing vendor lock-in and response time in serverless workflows by implementing function cluster migration and request redirection techniques.

## Overview

The FaasFlows-Demo-Config repository provides the necessary configuration files to define directed acyclic graph (DAG) structures for serverless function workflows. These configurations enable functions to communicate efficiently while reducing response time and mitigating vendor lock-in issues.

## Prerequisites

Before using this repository, ensure you have the following:

1. **Kubernetes cluster** with kubectl configured
2. **Helm** installed for deploying OpenFaaS
3. **Docker** installed for building custom images
4. **Pre-built FaasFlows-enabled images**:
    - The Dockerfile in this repository requires a pre-built `<your_username>/faas-netes:faasflows-0.1` image
    - This base image should contain the modified faas-netes component with FaasFlows functionality
    - You need to build this image first using the modified faas-netes repository before using this config repository
    - Example command to build the base image:
      ```bash
      # In the modified faas-netes repository
      docker build -t <your_username>/faas-netes:faasflows-0.1 .
      ```
5. **Modified FaasFlows components**:
    - Modified gateway image (e.g., `<your_username>/gateway:faasflows-0.2`)
    - These components implement the FaasFlows functionality necessary for workflow execution

## Repository Contents

- **faasflows-demo-configmap.yaml**: The Kubernetes ConfigMap that contains the DAG configuration for FaasFlows demo functions
- **custom-values.yaml**: Custom Helm values for deploying OpenFaaS with FaasFlows components
- **Dockerfile**: Used to build a custom faas-netes image with the FaasFlows configuration

## Configuration Structure

The DAG configuration defines the relationships between functions and their dependencies. Each function in the workflow contains:

- `args`: The arguments required by the function
- `children`: Dependencies on other functions, including argument mapping
- `caching`: Whether to enable caching for the function's responses
- `cache_ttl`: Time-to-live for cached responses (in seconds)
- `is_third_party`: Flag to indicate if the function is hosted on an external platform
- `third_party_url`: URL for external functions (when is_third_party is true)

## How to Use

### 1. Apply the ConfigMap

```bash
kubectl apply -f faasflows-demo-configmap.yaml
```

### 2. Build Custom faas-netes Image

```bash
# Create a temporary directory for the build
mkdir -p ~/faas-netes-build
cd ~/faas-netes-build

# Extract configuration from ConfigMap
kubectl get configmap -n openfaas flows-config -o jsonpath='{.data.config\.json}' > config.json

# Build new image
docker build -t <your_username>/faas-netes:faasflows-config .
```

### 3. Deploy or Upgrade OpenFaaS with Helm

```bash
# Install OpenFaaS with custom values
helm repo update
helm install openfaas openfaas/openfaas --namespace openfaas --values ~/custom-values.yaml

# OR

# Upgrade OpenFaaS with your custom components
helm upgrade openfaas openfaas/openfaas \
  --namespace openfaas \
  --values ~/custom-values.yaml
```
## Related Repositories
This repository is part of a larger FaasFlows implementation that includes:
- Modified faas-gateway 
- Modified faas-netes 
- Modified faas-provider 
- FaasFlows Demo Functions 
- Non-FaasFlows Demo Functions (for comparison)

## Implementation Notes
The DAG configuration in this repository enables the key features of FaasFlows:
- Function Cluster Migration: Determines which functions should be migrated together to reduce communication overhead. 
- Request Redirection: Optimizes request routing to reduce response time. 
- Caching: Implements caching strategies to improve performance for frequently called functions.
