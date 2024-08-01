#!/bin/bash

# Extract direct dependencies from go.mod using go mod edit -json
direct_deps=$(go mod edit -json | jq -r '.Require[] | select(.Indirect == null) | .Path')

# List all modules with their update status
output=$(go list -m -u all)

found_deprecated=false

while IFS= read -r line; do
    # Extract module path and update status
    mod_path=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')

    # Check if the module is a direct dependency
    if echo "$direct_deps" | grep -q "$mod_path"; then
        if [[ "$status" == *"deprecated"* || "$status" == *"retracted"* ]]; then
            echo "Deprecated/retracted direct dependency found: $line"
            found_deprecated=true
        fi
    fi
done <<< "$output"

if [ "$found_deprecated" = true ]; then
    echo "Exiting with failure due to deprecated direct dependencies."
    exit 1
fi