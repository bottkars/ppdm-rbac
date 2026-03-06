# PPDM RBAC Product Specification

## Overview

The PowerProtect Data Management (PPDM) Role-Based Access Control (RBAC) system provides Kubernetes-native permission management for PPDM components. This system automates the creation, annotation, and distribution of RBAC manifests across different deployment environments.

## Product Description

### Purpose
The PPDM RBAC system delivers fine-grained access control for PPDM services in Kubernetes clusters, ensuring secure operation while maintaining flexibility for different deployment scenarios.

### Key Features
- **Automated RBAC Generation**: Dynamic creation of RBAC manifests based on deployment requirements
- **Version-based Annotations**: Automatic annotation of resources with deployment version information
- **Multi-distribution Support**: Support for both OCI registry and GitHub raw file distribution
- **Branch-aware Deployment**: Automatic tagging and versioning based on git branch names
- **Validation Pipeline**: Built-in YAML syntax validation and structure verification

## Architecture

### System Components

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Git Repository │    │   Makefile       │    │   OCI Registry  │
│                 │    │   Automation     │    │   (quay.io)     │
│ - RBAC Files    │───▶│                  │───▶│                 │
│ - Scripts       │    │ - Annotation     │    │ - Annotated     │
│ - Documentation │    │ - Validation     │    │   Artifacts     │
│                 │    │ - Upload        │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │   GitHub         │
                       │   Distribution   │
                       │                  │
                       │ - Raw File Access│
                       │ - Version Tags   │
                       └──────────────────┘
```

### Data Flow

1. **Source Management**: RBAC definitions stored in git repository
2. **Annotation Pipeline**: Automatic version annotation injection
3. **Distribution**: Dual-path distribution to OCI registry and GitHub
4. **Consumption**: Multiple consumption methods for end-users

### RBAC Components

#### Controller RBAC (`ppdm-controller-rbac.yaml`)
- **Namespace**: `powerprotect`
- **ServiceAccount**: `ppdm-serviceaccount`
- **ClusterRole**: `powerprotect:cluster-role`
- **Role**: `ppdmrole`
- **Bindings**: Cluster and namespace-level role bindings

#### Discovery RBAC (`ppdm-discovery.yaml`)
- **Namespace**: `powerprotect`
- **ServiceAccount**: `ppdm-discovery-serviceaccount`
- **ClusterRole**: `powerprotect:discovery-clusterrole`
- **Role**: `ppdm-discovery-role`
- **ConfigMap**: `ppdm-custom-config-resources`

## Requirements

### Functional Requirements

#### FR-001: RBAC Generation
- The system SHALL generate complete RBAC manifests for PPDM components
- The system SHALL support both cluster-level and namespace-level permissions
- The system SHALL include all necessary ServiceAccounts, Roles, and Bindings

#### FR-002: Version Annotation
- The system SHALL automatically annotate all Kubernetes resources with version information
- The system SHALL use the annotation key `powerprotect.dell.com/version`
- The system SHALL extract version value from git branch names
- The system SHALL apply annotations to all resources with `metadata` sections

**Example Annotation Format:**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ppdm-serviceaccount
  namespace: powerprotect
  annotations:
    powerprotect.dell.com/version: "20.1.0.0-1-SNAPSHOT"
```

#### FR-003: Distribution
- The system SHALL upload annotated manifests to OCI registry
- The system SHALL maintain manifests in git repository for direct access
- The system SHALL support multiple consumption methods

#### FR-004: Validation
- The system SHALL validate YAML syntax before distribution
- The system SHALL verify Kubernetes resource structure
- The system SHALL provide clear error reporting for validation failures

### Non-Functional Requirements

#### NFR-001: Performance
- Annotation processing SHALL complete within 30 seconds for typical manifests
- Upload operations SHALL complete within 2 minutes
- Validation SHALL complete within 10 seconds

#### NFR-002: Reliability
- The system SHALL maintain 99.9% availability for distribution endpoints
- The system SHALL provide backup and recovery mechanisms
- The system SHALL implement atomic operations for file modifications

#### NFR-003: Security
- RBAC manifests SHALL follow principle of least privilege
- The system SHALL use secure authentication for registry operations
- The system SHALL not expose sensitive information in annotations

#### NFR-004: Maintainability
- The system SHALL use declarative configuration
- The system SHALL provide comprehensive documentation
- The system SHALL implement automated testing

### Technical Requirements

#### TR-001: Environment Support
- The system SHALL support macOS development environments
- The system SHALL support Linux production environments
- The system SHALL require Kubernetes 1.20+

#### TR-002: Tool Dependencies
- The system SHALL require `yq` for YAML processing
- The system SHALL require `oras` for OCI operations
- The system SHALL require `make` for automation

#### TR-003: Registry Integration
- The system SHALL integrate with quay.io registry
- The system SHALL support OCI artifact specification
- The system SHALL implement proper authentication

## Deployment Scenarios

### Scenario 1: Development Environment
```bash
# Local development and testing
make setup
make validate
make annotate
make upload

# Example: Annotated RBAC manifest
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: powerprotect:cluster-role
  annotations:
    powerprotect.dell.com/version: "20.1.0.0-1-SNAPSHOT"
  labels:
    app.kubernetes.io/part-of: powerprotect.dell.com
rules:
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["create", "delete", "get", "list", "watch"]
```

### Scenario 2: Production Deployment
```bash
# Method 1: OCI Registry Pull
oras pull quay.io/delldps/ppdm-rbac/ppdm-controller-rbac:production
oc apply -f ppdm-controller-rbac.yaml

# Method 2: GitHub Raw Access
oc apply -f https://raw.githubusercontent.com/dell-dps/ppdm-rbac/production/ppdm-controller-rbac.yaml

# Example: Applied RBAC with version annotation
apiVersion: v1
kind: Namespace
metadata:
  name: powerprotect
  annotations:
    powerprotect.dell.com/version: "production"
  labels:
    app.kubernetes.io/part-of: powerprotect.dell.com
```

### Scenario 3: Multi-branch Management
```bash
# Feature branch development
git checkout feature/new-permissions
make all  # Creates versioned artifacts for feature branch

# Production release
git checkout main
make all  # Creates production artifacts

# Example: Feature branch annotation
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: powerprotect:cluster-role-binding
  annotations:
    powerprotect.dell.com/version: "feature/new-permissions"
  labels:
    app.kubernetes.io/part-of: powerprotect.dell.com
subjects:
  - kind: ServiceAccount
    name: ppdm-serviceaccount
    namespace: powerprotect
roleRef:
  kind: ClusterRole
  name: powerprotect:cluster-role
  apiGroup: rbac.authorization.k8s.io
```

## Quality Assurance

### Testing Strategy
- **Unit Tests**: YAML structure validation
- **Integration Tests**: End-to-end workflow testing
- **Security Tests**: Permission boundary verification
- **Performance Tests**: Upload and processing timing

### Validation Criteria
- All YAML files pass syntax validation
- All resources receive proper version annotations
- OCI uploads complete successfully
- GitHub raw links remain accessible

## Governance

### Version Management
- Semantic versioning based on git branches
- Automatic version annotation injection
- Immutable artifact storage in OCI registry

### Access Control
- Registry access controlled through quay.io permissions
- Git repository access through GitHub permissions
- Branch protection for production releases

### Compliance
- RBAC manifests follow Kubernetes security best practices
- Regular security audits of permission sets
- Documentation of all granted permissions

## Future Enhancements

### Planned Features
- **Multi-registry Support**: Support for additional OCI registries
- **Template System**: Parameterized RBAC generation
- **Audit Logging**: Comprehensive access logging
- **Automated Testing**: CI/CD integration for validation

### Scalability Considerations
- Support for large-scale multi-cluster deployments
- Performance optimization for enterprise environments
- Integration with enterprise identity management systems

## Support and Maintenance

### Documentation
- Comprehensive README with usage examples
- API documentation for integration points
- Troubleshooting guide for common issues

### Monitoring
- Registry access monitoring
- Git repository activity tracking
- Performance metrics collection

### Support Channels
- GitHub Issues for bug reports and feature requests
- Documentation updates through pull requests
- Community support through discussion forums
