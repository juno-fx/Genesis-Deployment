#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHART_DIR="$SCRIPT_DIR/.."
SCHEMA_DIR="$SCRIPT_DIR/../.tmp-schemas"

echo "Linting Helm chart with kubeconform in strict mode..."


declare schema_locations=()

# Popular open-source projects' CRDs can be found in this json schema catalog: https://github.com/datreeio/CRDs-catalog
# Ours are built within our lint CI, see. hack/* for how.
schema_locations+=("-schema-location" "default")
schema_locations+=("-schema-location" "https://raw.githubusercontent.com/datreeio/CRDs-catalog/refs/heads/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json")
schema_locations+=("-schema-location" "$SCHEMA_DIR/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json")


echo "Linting with the following schema files: ${schema_locations[*]}"

# skip CustomResourceDefinition ignores the actual CRDs, since there's no hard schema for them.
# We still validate they are valid OpenAPI below
helm template "${CHART_DIR}" -f "${SCRIPT_DIR}/test-values.yaml" | kubeconform \
  -strict \
  -summary \
  -skip CustomResourceDefinition \
  "${schema_locations[@]}" \

helm template "${CHART_DIR}" -f "${SCRIPT_DIR}/test-values.yaml" | yq > /dev/null
