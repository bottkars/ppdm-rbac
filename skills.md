this directory contains rbac files for ppdm
the files are:
- ppdm-controller-rbac.yaml
- ppdm-discovery.yaml
base on the git branch, the ressources in the rpac file need to be annotated with:
poverprotect.dell.com/version::{branch name}
the files need to pe uploaded and tagged to quay.io/delldps/ppdm-rbac:{branch name}

## Required Tools

- yq - YAML processor for adding annotations
- oras - OCI registry client for uploading YAML files
- make - Build automation tool

## Installation

### macOS
```bash
# Install yq
brew install yq

# Install oras
brew install oras

# Install make (usually pre-installed)
brew install make
```

### Manual Installation
```bash
# Install yq (binary)
curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_darwin_amd64 -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq

# Install oras (binary)
curl -L https://github.com/oras-project/oras/releases/latest/download/oras_darwin_amd64 -o /usr/local/bin/oras
chmod +x /usr/local/bin/oras
```

## Authentication

Before uploading, authenticate with quay.io:
```bash
oras login quay.io
# or
docker login quay.io
```

## Applying RBAC Files

After uploading to OCI registry, files can be applied using either method:

### Method 1: Pull with oras and apply locally
```bash
# Pull controller RBAC
oras pull quay.io/delldps/ppdm-rbac/ppdm-controller-rbac:{branch-name}
oc apply -f ppdm-controller-rbac.yaml

# Pull discovery RBAC
oras pull quay.io/delldps/ppdm-rbac/ppdm-discovery:{branch-name}
oc apply -f ppdm-discovery.yaml
```

### Method 2: Apply from GitHub raw link
```bash
# Apply controller RBAC
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/{branch-name}/ppdm-controller-rbac.yaml

# Apply discovery RBAC
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/{branch-name}/ppdm-discovery.yaml
```

Note: oc apply does not support direct oci:// links. Use oras pull + local apply or GitHub raw links.
