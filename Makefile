# PPDM RBAC Makefile
# Variables
BRANCH := $(shell git branch --show-current)
VERSION := powerprotect.dell.com/version::$(BRANCH)
REGISTRY := quay.io/delldps/ppdm-rbac
OCI_REGISTRY := oci://dell-dps/ppdm-rbac

# YAML files to process
RBAC_FILES := ppdm-controller-rbac.yaml ppdm-discovery.yaml

# Default target
.PHONY: all
all: annotate upload

# Get current branch
.PHONY: branch
branch:
	@echo "Current branch: $(BRANCH)"
	@echo "Registry: $(REGISTRY)"
	@echo "OCI Registry: $(OCI_REGISTRY)"

# Add version annotations to all YAML files
.PHONY: annotate
annotate:
	@echo "Adding version annotation $(VERSION) to RBAC files..."
	@for file in $(RBAC_FILES); do \
		echo "Processing $$file..."; \
		./scripts/annotate.sh $$file "$(VERSION)"; \
	done
	@echo "Annotation complete."

# Upload YAML files to OCI registry
.PHONY: upload
upload:
	@echo "Uploading YAML files to $(REGISTRY):$(BRANCH)..."
	@for file in $(RBAC_FILES); do \
		echo "Uploading $$file..."; \
		./scripts/upload-oci.sh $$file $(REGISTRY) $(BRANCH); \
	done
	@echo "Upload complete."
	@echo ""
	@echo "Files can now be applied with:"
	@echo "oc apply $(OCI_REGISTRY)/$$file:$(BRANCH)"

# Validate YAML syntax
.PHONY: validate
validate:
	@echo "Validating YAML files..."
	@for file in $(RBAC_FILES); do \
		echo "Validating $$file..."; \
		yq eval . $$file > /dev/null; \
	done
	@echo "Validation complete."

# Clean up temporary files
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -f *.bak
	rm -f *.tmp
	@echo "Clean complete."

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all      - Run annotate and upload"
	@echo "  annotate - Add version annotations to YAML files"
	@echo "  upload   - Upload YAML files to OCI registry"
	@echo "  validate - Validate YAML syntax"
	@echo "  clean    - Clean up temporary files"
	@echo "  branch   - Show current branch and registry info"
	@echo "  help     - Show this help message"

# Create required directories and scripts
.PHONY: setup
setup:
	@echo "Setting up project structure..."
	mkdir -p scripts
	@echo "Creating annotation script..."
	@if [ ! -f scripts/annotate.sh ]; then \
		echo '#!/bin/bash' > scripts/annotate.sh; \
		echo 'FILE=$$1' >> scripts/annotate.sh; \
		echo 'VERSION=$$2' >> scripts/annotate.sh; \
		echo '' >> scripts/annotate.sh; \
		echo 'if [ -z "$$FILE" ] || [ -z "$$VERSION" ]; then' >> scripts/annotate.sh; \
		echo '    echo "Usage: $$0 <file> <version>"' >> scripts/annotate.sh; \
		echo '    exit 1' >> scripts/annotate.sh; \
		echo 'fi' >> scripts/annotate.sh; \
		echo '' >> scripts/annotate.sh; \
		echo '# Create backup' >> scripts/annotate.sh; \
		echo 'cp "$$FILE" "$$FILE.bak"' >> scripts/annotate.sh; \
		echo '' >> scripts/annotate.sh; \
		echo '# Extract version from annotation format' >> scripts/annotate.sh; \
		echo 'VERSION_VALUE=$$(echo "$$VERSION" | sed '"'"'s/.*:://'"'"')' >> scripts/annotate.sh; \
		echo '' >> scripts/annotate.sh; \
		echo '# Add annotation to all resources' >> scripts/annotate.sh; \
		echo 'yq eval '"'"'select(.metadata != null) | .metadata.annotations = (.metadata.annotations // {}) | .metadata.annotations += {"powerprotect.dell.com/version": "'"'$$VERSION_VALUE'"'" }'"'"' "$$FILE" > "$$FILE.tmp"' >> scripts/annotate.sh; \
		echo 'mv "$$FILE.tmp" "$$FILE"' >> scripts/annotate.sh; \
		echo 'echo "Added annotation $$VERSION_VALUE to $$FILE"' >> scripts/annotate.sh; \
		chmod +x scripts/annotate.sh; \
	fi
	@echo "Creating OCI upload script..."
	@if [ ! -f scripts/upload-oci.sh ]; then \
		echo '#!/bin/bash' > scripts/upload-oci.sh; \
		echo 'FILE=$$1' >> scripts/upload-oci.sh; \
		echo 'REGISTRY=$$2' >> scripts/upload-oci.sh; \
		echo 'TAG=$$3' >> scripts/upload-oci.sh; \
		echo '' >> scripts/upload-oci.sh; \
		echo 'if [ -z "$$FILE" ] || [ -z "$$REGISTRY" ] || [ -z "$$TAG" ]; then' >> scripts/upload-oci.sh; \
		echo '    echo "Usage: $$0 <file> <registry> <tag>"' >> scripts/upload-oci.sh; \
		echo '    exit 1' >> scripts/upload-oci.sh; \
		echo 'fi' >> scripts/upload-oci.sh; \
		echo '' >> scripts/upload-oci.sh; \
		echo '# Extract filename without extension' >> scripts/upload-oci.sh; \
		echo 'BASENAME=$$(basename "$$FILE" .yaml)' >> scripts/upload-oci.sh; \
		echo 'OCI_PATH="$$REGISTRY/$$BASENAME:$$TAG"' >> scripts/upload-oci.sh; \
		echo '' >> scripts/upload-oci.sh; \
		echo '# Create OCI artifact from YAML file' >> scripts/upload-oci.sh; \
		echo 'echo "Creating OCI artifact: $$OCI_PATH"' >> scripts/upload-oci.sh; \
		echo 'oras push "$$OCI_PATH" "$$FILE:application/vnd.yaml"' >> scripts/upload-oci.sh; \
		echo '' >> scripts/upload-oci.sh; \
		echo 'echo "Uploaded $$FILE to $$OCI_PATH"' >> scripts/upload-oci.sh; \
		chmod +x scripts/upload-oci.sh; \
	fi
	@echo "Setup complete."
