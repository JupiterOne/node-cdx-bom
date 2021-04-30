#!/bin/bash
set -euo pipefail

OUTPUT_BOMFILE=bom.json

PROJROOT=$(pwd)

if [ ! -d node_modules ]; then
  echo "You must first install NPM packages!"
  exit 2
fi

echo "Finding packages..."
find . -name package.json | grep -v node_modules | grep -v deploy | while read dir; do
  cd "$PROJROOT"
  cd "$(dirname $dir)"
  if [ "$(ls node_modules 2>/dev/null)" ]; then
    echo "Generating BOM for $dir..."
    cyclonedx-bom
  fi
done

echo
echo "Merging BOM file(s)..."
~/Downloads/cyclonedx-osx-x64 merge --input-files $(paste -s -d ' ' <(find . -name bom.xml)) --output-format json --output-file "$OUTPUT_BOMFILE"

echo
echo "Cleanup intermediate files..."
find . -name bom.xml -exec rm {} \;

echo
echo "Deduping BOM file..."
echo "Before: $(jq '.components | length' "$OUTPUT_BOMFILE") packages"
node ./filterBOM.js "./${OUTPUT_BOMFILE}"
echo "After: $(jq '.components | length' "$OUTPUT_BOMFILE") packages"

echo
echo "Analyzing BOM..."
~/Downloads/cyclonedx-osx-x64 analyze --input-file "$OUTPUT_BOMFILE" --multiple-component-versions

echo
echo "Validating BOM..."
~/Downloads/cyclonedx-osx-x64 validate --input-format json_v1_2 --input-file "$OUTPUT_BOMFILE" --fail-on-errors

echo "Generated BOM file $OUTPUT_BOMFILE - OK"