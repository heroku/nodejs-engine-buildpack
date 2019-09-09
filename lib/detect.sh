#!/usr/bin/env bash

set -eo pipefail

detect_package_json() {
  if [[ ! -f package.json ]]; then
    exit 100
  fi
}
