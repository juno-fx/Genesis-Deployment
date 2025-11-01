#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CRD_DIR="$SCRIPT_DIR/../templates/crds"
SCHEMA_TMP_DIR="$SCRIPT_DIR/../.tmp-schemas"

# Create the tmp schema directory if it doesn't exist
mkdir -p "$SCHEMA_TMP_DIR"

# Generate JSON schemas from CRDs
for file in "$CRD_DIR"/*.yaml; do
    echo "Generating schema for $file"
    python3 "$SCRIPT_DIR/openapi2jsonschema.py" --output-dir "$SCHEMA_TMP_DIR" "$file"
done

echo "Schema generation complete. Schemas stored in $SCHEMA_TMP_DIR"
