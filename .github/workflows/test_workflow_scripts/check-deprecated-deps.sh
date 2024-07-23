#!/bin/bash

# Run `go list -m -u all` to list all dependencies and their updates
output=$(go list -m -u all)

warnings=""

# Check for deprecated dependencies
echo "$output" | while IFS= read -r line; do
    if [[ "$line" == *"deprecated"* ]]; then
        echo "Deprecated dependency found: $line"
        warnings+="Deprecated dependency found: $line\n"
    fi
done

echo -e "$warnings"