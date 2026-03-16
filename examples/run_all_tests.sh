#!/bin/bash
# Run all DiracQ test scripts
# Usage: ./examples/run_all_tests.sh  (from repo root)
#    or: cd examples && ./run_all_tests.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT"

test_files=()
failed_tests=()

for test_file in examples/test_*.wls; do
    echo ""
    echo "========================================"
    echo "Running: $(basename "$test_file")"
    echo "========================================"
    if wolframscript -file "$test_file" 2>&1; then
        test_files+=("PASS: $(basename "$test_file")")
    else
        test_files+=("FAIL: $(basename "$test_file")")
        failed_tests+=("$test_file")
    fi
done

echo ""
echo "========================================"
echo "          SUMMARY"
echo "========================================"
for entry in "${test_files[@]}"; do
    echo "  $entry"
done
echo ""
if [ ${#failed_tests[@]} -eq 0 ]; then
    echo "All test files passed!"
else
    echo "${#failed_tests[@]} test file(s) had failures."
    exit 1
fi
