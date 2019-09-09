#!/usr/bin/env bash

json_get_key() {
  local file="$1"
  local key="$2"

  if test -f "$file"; then
    cat "$file" | jq -c -M --raw-output "$key // \"\"" || return 1
  else
    echo ""
  fi
}
