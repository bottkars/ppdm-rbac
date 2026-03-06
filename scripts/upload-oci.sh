#!/bin/bash

FILE=$1
REGISTRY=$2
TAG=$3

if [ -z "$FILE" ] || [ -z "$REGISTRY" ] || [ -z "$TAG" ]; then
    echo "Usage: $0 <file> <registry> <tag>"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File $FILE does not exist"
    exit 1
fi

# Extract filename without extension
BASENAME=$(basename "$FILE" .yaml)
OCI_PATH="$REGISTRY/$BASENAME:$TAG"

# Create OCI artifact from YAML file
echo "Creating OCI artifact: $OCI_PATH"
oras push "$OCI_PATH" "$FILE:application/vnd.yaml"

echo "Uploaded $FILE to $OCI_PATH"
