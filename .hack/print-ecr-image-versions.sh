#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


tmp_file=$(mktemp)

cp "${SCRIPT_DIR}/../values.yaml" "${tmp_file}"
sed -i "s|registry:.*|registry: 709825985650.dkr.ecr.us-east-1.amazonaws.com/juno-innovations|g" "$tmp_file"


helm template --values "${tmp_file}" "${SCRIPT_DIR}/.." | yq -r '.. | objects | .containers?[]? | .image?' | sort -u
