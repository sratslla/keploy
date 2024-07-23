#!/bin/bash

# Run `go list -m -u all` to list all dependencies.
output=$(go list -m -u all)


# Checking for deprecated dependencies.
found_deprecated=false
echo "$output" | while IFS= read -r line; do
    if [[ "$line" == *"deprecated"* ]]; then
        echo "Deprecated dependency found: $line"
        found_deprecated=true
    fi
done

if [ "$found_deprecated" = true ]; then
    echo "Exiting with failure due to deprecated dependencies."
    exit 1
fi