#!/bin/bash
# Naming Convention Check Script for VitaStellar Contracts
# This script helps identify naming inconsistencies across the codebase

set -euo pipefail

echo "🔍 Checking naming conventions across VitaStellar Contracts..."
echo "======================================================"

VIOLATIONS=0

# Check for non-snake_case function names
echo ""
echo "1. Checking function names (should be snake_case)..."
echo "--------------------------------------------------"
FUNCTION_VIOLATIONS=$(find contracts -name "*.rs" -type f -exec grep -H "pub fn [A-Z]" {} \; | wc -l)
if [ "$FUNCTION_VIOLATIONS" -gt 0 ]; then
  find contracts -name "*.rs" -type f -exec grep -H "pub fn [A-Z]" {} \; | head -20
  VIOLATIONS=$((VIOLATIONS + FUNCTION_VIOLATIONS))
fi

# Check for non-SCREAMING_SNAKE_CASE constants
echo ""
echo "2. Checking constant names (should be SCREAMING_SNAKE_CASE)..."
echo "------------------------------------------------------------"
CONST_VIOLATIONS=$(find contracts -name "*.rs" -type f -exec grep -H "const [a-z]" {} \; | wc -l)
if [ "$CONST_VIOLATIONS" -gt 0 ]; then
  find contracts -name "*.rs" -type f -exec grep -H "const [a-z]" {} \; | head -20
  VIOLATIONS=$((VIOLATIONS + CONST_VIOLATIONS))
fi

# Check for non-PascalCase type definitions
echo ""
echo "3. Checking type names (should be PascalCase)..."
echo "------------------------------------------------"
STRUCT_VIOLATIONS=$(find contracts -name "*.rs" -type f -exec grep -H "struct [a-z]" {} \; | wc -l)
ENUM_VIOLATIONS=$(find contracts -name "*.rs" -type f -exec grep -H "enum [a-z]" {} \; | wc -l)
if [ "$STRUCT_VIOLATIONS" -gt 0 ]; then
  find contracts -name "*.rs" -type f -exec grep -H "struct [a-z]" {} \; | head -10
  VIOLATIONS=$((VIOLATIONS + STRUCT_VIOLATIONS))
fi
if [ "$ENUM_VIOLATIONS" -gt 0 ]; then
  find contracts -name "*.rs" -type f -exec grep -H "enum [a-z]" {} \; | head -10
  VIOLATIONS=$((VIOLATIONS + ENUM_VIOLATIONS))
fi

# Check for Err instead of Error
echo ""
echo "4. Checking for 'Err' instead of 'Error'..."
echo "------------------------------------------"
ERR_VIOLATIONS=$(find contracts -name "*.rs" -type f -exec grep -H "enum Err" {} \; | wc -l)
if [ "$ERR_VIOLATIONS" -gt 0 ]; then
  find contracts -name "*.rs" -type f -exec grep -H "enum Err" {} \;
  VIOLATIONS=$((VIOLATIONS + ERR_VIOLATIONS))
fi

echo ""
echo "======================================================"
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "❌ $VIOLATIONS naming violation(s) found!"
  echo ""
  echo "To fix issues, refer to:"
  echo "  - docs/CODING_STANDARDS.md for naming conventions"
  echo "  - .clippy.toml for linting rules"
  echo ""
  echo "Run 'cargo clippy -- -D warnings' for detailed linting."
  exit 1
else
  echo "✅ Naming check complete! No violations found."
  exit 0
fi