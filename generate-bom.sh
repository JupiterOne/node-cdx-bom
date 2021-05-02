#!/bin/bash
set -euo pipefail

main() {
  echo "Finding packages..."
  # generate bom.xml everywhere node_modules and package.json are found together,
  # but do not descend into the node_modules dirs themselves. Also, ignore paths related
  # to deployment (these packages are inherently devDeps).
  find . -name package.json | grep -v node_modules | grep -v deploy | while read dir; do
    cd "$PROJROOT"
    cd "$(dirname $dir)"
    if [ "$(ls node_modules 2>/dev/null)" ]; then
      # node_modules dir is present and not empty
      echo "Generating BOM for $dir..."
      cyclonedx-bom
    fi
  done

  echo
  echo "Merging BOM file(s)..."
  cyclonedx merge --output-format json --output-file "$OUTPUT_BOMFILE" --input-files $(paste -s -d ' ' <(find "$PROJROOT" -name bom.xml))

  echo
  echo "Cleanup intermediate files..."
  find . -name bom.xml -exec rm {} \;

  echo
  echo "Deduping BOM file..."
  echo "Before: $(jq '.components | length' "$OUTPUT_BOMFILE") packages"
  node "$ORIGROOT/filterBOM.js" "${OUTPUT_BOMFILE}"
  echo " After: $(jq '.components | length' "$OUTPUT_BOMFILE") packages"

  echo
  echo "Analyzing BOM..."
  cyclonedx analyze --input-file "$OUTPUT_BOMFILE" --multiple-component-versions

  echo
  echo "Validating BOM..."
  cyclonedx validate --input-format json_v1_2 --input-file "$OUTPUT_BOMFILE" --fail-on-errors

  echo "Generated BOM file $OUTPUT_BOMFILE - OK"
}

fail() {
  echo "$*"
  exit 2
}

ORIGROOT="$PWD"
PROJROOT="${1:-$PWD}"
[ ! -d "$PROJROOT" ] && fail "Couldn't find $PROJROOT or volume not mounted!"
cd "$PROJROOT" || fail "Couldn't switch to $PROJROOT directory!"
OUTPUT_BOMFILE="${2:-$PROJROOT/bom.json}"

[ ! -d node_modules ] && fail "You must first install NPM packages!"

OUTPUT_DIR="$(dirname $OUTPUT_BOMFILE)"
mkdir -p "$OUTPUT_DIR" || fail "Couldn't create output dir for $OUTPUT_BOMFILE"
echo "Generating $OUTPUT_BOMFILE..."

main