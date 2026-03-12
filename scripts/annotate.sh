#!/bin/bash

FILE=$1
VERSION=$2
FEATURE=$3

if [ -z "$FILE" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <file> <version> [feature]"
    echo "Example: $0 ppdm-controller-rbac.yaml '20.1.0.0-1-SNAPSHOT' 'new-permissions'"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File $FILE does not exist"
    exit 1
fi

# Create backup
cp "$FILE" "$FILE.bak"

# Extract version from annotation format (powerprotect.dell.com/version::branch)
VERSION_VALUE=$(echo "$VERSION" | sed 's/.*:://')

# Build yq command for annotations
ANNOTATIONS_CMD='select(.metadata != null) | .metadata.annotations = (.metadata.annotations // {}) | .metadata.annotations += {"powerprotect.dell.com/version": "'"$VERSION_VALUE"'" }'

# Add feature annotation if provided
if [ ! -z "$FEATURE" ]; then
    ANNOTATIONS_CMD="$ANNOTATIONS_CMD | .metadata.annotations += {\"powerprotect.dell.com/feature\": \"$FEATURE\"}"
    echo "Adding version annotation $VERSION_VALUE and feature annotation $FEATURE to $FILE"
else
    echo "Adding version annotation $VERSION_VALUE to $FILE"
fi

# Apply annotations using yq
yq eval "$ANNOTATIONS_CMD" "$FILE" > "$FILE.tmp"

mv "$FILE.tmp" "$FILE"
