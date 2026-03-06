# PPDM RBAC Project

This project contains Kubernetes RBAC manifests for PowerProtect Data Management (PPDM) that are uploaded to an OCI registry for direct application with `oc apply`.

## Files

- `ppdm-controller-rbac.yaml` - Controller RBAC permissions
- `ppdm-discovery.yaml` - Discovery service RBAC permissions

## Make Targets

### Setup
```bash
make setup          # Create required directories and scripts
make help           # Show all available targets
```

### Development Workflow
```bash
make branch         # Show current git branch and registry info
make validate       # Validate YAML syntax
make annotate       # Add version annotations to all resources
make upload         # Upload YAML files to OCI registry
make all            # Run annotate and upload in sequence
```

### Utilities
```bash
make clean          # Clean up temporary files
```

## Version Annotations

All Kubernetes resources are automatically annotated with:
```
powerprotect.dell.com/version::{branch_name}
```

The annotation is added to the `metadata.annotations` section of each resource.

## OCI Registry Upload

YAML files are uploaded directly to OCI registry:
- Registry: `quay.io/delldps/ppdm-rbac`
- Files are tagged with branch name
- Each YAML becomes a separate OCI artifact

## Usage with oc apply

After upload, files can be applied using either method:

### Method 1: Pull with oras and apply locally
```bash
# Pull controller RBAC
oras pull quay.io/delldps/ppdm-rbac/ppdm-controller-rbac:20.1.0.0-1-SNAPSHOT
oc apply -f ppdm-controller-rbac.yaml

# Pull discovery RBAC
oras pull quay.io/delldps/ppdm-rbac/ppdm-discovery:20.1.0.0-1-SNAPSHOT
oc apply -f ppdm-discovery.yaml
```

### Method 2: Apply from GitHub raw link
```bash
# Apply controller RBAC
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/20.1.0.0-1-SNAPSHOT/ppdm-controller-rbac.yaml

# Apply discovery RBAC
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/20.1.0.0-1-SNAPSHOT/ppdm-discovery.yaml
```

## Requirements

- `yq` (YAML processor)
- `oras` (OCI registry client)
- `make`

## Usage

1. Checkout the desired branch
2. Run `make setup` (first time only)
3. Run `make all` to annotate and upload
4. Or run individual steps as needed

## Example

```bash
# On branch 20.1
make setup    # First time setup
make all      # Annotate and upload

# This will:
# 1. Add annotation powerprotect.dell.com/version::20.1.0.0-1-SNAPSHOT to all resources
# 2. Upload ppdm-controller-rbac.yaml to quay.io/delldps/ppdm-rbac/ppdm-controller-rbac:20.1.0.0-1-SNAPSHOT
# 3. Upload ppdm-discovery.yaml to quay.io/delldps/ppdm-rbac/ppdm-discovery:20.1.0.0-1-SNAPSHOT

# Then apply with either method:
# Method 1: Pull with oras and apply locally
oras pull quay.io/delldps/ppdm-rbac/ppdm-controller-rbac:20.1.0.0-1-SNAPSHOT
oc apply -f ppdm-controller-rbac.yaml

oras pull quay.io/delldps/ppdm-rbac/ppdm-discovery:20.1.0.0-1-SNAPSHOT
oc apply -f ppdm-discovery.yaml

# Method 2: Apply from GitHub raw link
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/20.1.0.0-1-SNAPSHOT/ppdm-controller-rbac.yaml
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/20.1.0.0-1-SNAPSHOT/ppdm-discovery.yaml
```
