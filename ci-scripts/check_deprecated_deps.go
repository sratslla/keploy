// ci-scripts/check_deprecated_deps.go
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	cmd := exec.Command("go", "list", "-m", "-u", "all")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Error running go list:", err)
		os.Exit(1)
	}

	lines := strings.Split(string(output), "\n")
	warnings := []string{}
	for _, line := range lines {
		if strings.Contains(line, "deprecated") {
			warnings = append(warnings, line)
		}
	}

	if len(warnings) > 0 {
		for _, warning := range warnings {
			fmt.Println("::warning file=go.mod::Deprecated dependency found:", warning)
		}
		fmt.Printf("::set-output name=deprecated-warnings::%d deprecated dependencies found.\n", len(warnings))
	} else {
		fmt.Println("No deprecated dependencies found.")
	}
}
