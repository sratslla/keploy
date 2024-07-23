#!/bin/bash

# Run `go list -m -u all` to list all dependencies and their updates
output=$(go list -m -u all)

# Check for deprecated dependencies
echo "$output" | while IFS= read -r line; do
    if [[ "$line" == *"deprecated"* ]]; then
        echo "Deprecated dependency found: $line"
    fi
done
