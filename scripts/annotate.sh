#!/bin/bash

FILE=$1
VERSION=$2

if [ -z "$FILE" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <file> <version>"
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

# Add annotation to all resources using yq
yq eval 'select(.metadata != null) | .metadata.annotations = (.metadata.annotations // {}) | .metadata.annotations += {"powerprotect.dell.com/version": "'"$VERSION_VALUE"'" }' "$FILE" > "$FILE.tmp"

mv "$FILE.tmp" "$FILE"

echo "Added version annotation $VERSION_VALUE to $FILE"
