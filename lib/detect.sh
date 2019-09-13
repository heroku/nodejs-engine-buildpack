#!/usr/bin/env bash

detect_package_json() {
  current_dir=$1
  [[ -f "$current_dir/package.json" ]]
}
