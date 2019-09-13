#!/usr/bin/env bash

detect_package_json() {
  local build_dir=$1
  [[ -f "$build_dir/package.json" ]]
}
