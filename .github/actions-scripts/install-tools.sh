#!/usr/bin/env bash
#
# Iterate over the `tools` action input line-by-line, stripping blanks and
# comments, then invoke ubi for each remaining line. Each line is passed
# verbatim as args, so users can use any flag ubi understands.
#
# Required env vars:
#   UBI_BIN     - absolute path to the ubi binary
#   TOOLS       - the raw `tools` input (multi-line string)
#   DEFAULT_IN  - default `--in` directory to use when a line doesn't specify one

set -euo pipefail

: "${UBI_BIN:?UBI_BIN is required}"
: "${TOOLS:?TOOLS is required}"
: "${DEFAULT_IN:?DEFAULT_IN is required}"

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
    # Strip leading/trailing whitespace.
    line="${raw_line#"${raw_line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip blank lines and comments.
    if [ -z "$line" ] || [ "${line#\#}" != "$line" ]; then
        continue
    fi

    # Inject default --in if the line doesn't specify one.
    if ! printf '%s\n' "$line" | grep -qE '(^| )--in( |=)'; then
        line="$line --in $DEFAULT_IN"
    fi

    echo "ubi $line"
    # Word-split intentionally so flags and values become separate args.
    # shellcheck disable=SC2086
    "$UBI_BIN" $line
done <<EOF
$TOOLS
EOF
