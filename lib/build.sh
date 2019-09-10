#!/usr/bin/env bash

set -e

bp_dir=$(cd "$(dirname "$BASH_SOURCE")"; cd ..; pwd)

source "$bp_dir/lib/utils/json.sh"

bootstrap_buildpack() {
  if [[ ! -f $bp_dir/bin/resolve-version ]]; then
    echo "---> Bootstrapping buildpack"
    bash -- "$bp_dir/bin/bootstrap" "$bp_dir"
  fi
}

install_or_reuse_parse_tools() {
  local layer_dir=$1

  mkdir -p "${layer_dir}"

  if [[ ! -f "${layer_dir}/jq" ]]; then
    curl -Ls https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > "${layer_dir}/jq" \
      && chmod +x "${layer_dir}/jq"
  fi

  if [[ ! -f "${layer_dir}/yj" ]]; then
    curl -Ls https://github.com/sclevine/yj/releases/download/v2.0/yj-linux > "${layer_dir}/yj" \
      && chmod +x "${layer_dir}/yj"
  fi

  echo "cache = true" > "${layer_dir}.toml"
  echo "build = true" >> "${layer_dir}.toml"
  echo "launch = false" >> "${layer_dir}.toml"
}

install_or_reuse_node() {
  local layer_dir=$1
  local build_dir=$2

  local engine_node
  local node_version
  local resolved_data
  local node_url

  engine_node=$(json_get_key "$build_dir/package.json" ".engines.node")
  node_version=${engine_node:-10.x}
  resolved_data=$(resolve-version node "$node_version")
  node_url=$(echo "$resolved_data" | cut -f2 -d " ")
  node_version=$(echo "$resolved_data" | cut -f1 -d " ")

  if [[ $node_version == $([[ -f "${layer_dir}.toml" ]] && cat "${layer_dir}.toml" | yj -t | jq -r ".metadata.version") ]]; then
    echo "---> Reusing Node v${node_version}"
  else
    echo "---> Downloading and extracting Node v${node_version}"

    mkdir -p "${layer_dir}"
    rm -rf "${layer_dir}"/*

    echo "cache = true" > "${layer_dir}.toml"
    echo "build = true" >> "${layer_dir}.toml"
    echo "launch = true" >> "${layer_dir}.toml"
    echo -e "[metadata]\nversion = \"$node_version\"" >> "${layer_dir}.toml"

    curl -sL "$node_url" | tar xz --strip-components=1 -C "$layer_dir"
  fi
}

install_or_reuse_yarn() {
  local layer_dir=$1
  local build_dir=$2

  local engine_yarn
  local yarn_version
  local resolved_data
  local yarn_url

  engine_yarn=$(json_get_key "$build_dir/package.json" ".engines.yarn")
  yarn_version=${engine_yarn:-1.x}
  resolved_data=$(resolve-version yarn "$yarn_version")
  yarn_url=$(echo "$resolved_data" | cut -f2 -d " ")
  yarn_version=$(echo "$resolved_data" | cut -f1 -d " ")

  if [[ $yarn_version == $([[ -f "${layer_dir}.toml" ]] && cat "${layer_dir}.toml" | yj -t | jq -r ".metadata.version") ]]; then
    echo "---> Reusing yarn@${yarn_version}"
  else
    echo "---> Installing yarn@${yarn_version}"

    mkdir -p "$layer_dir"
    rm -rf "$layer_dir"/*

    echo "cache = true" > "${layer_dir}.toml"
    echo "build = true" >> "${layer_dir}.toml"
    echo "launch = true" >> "${layer_dir}.toml"
    echo -e "[metadata]\nversion = \"$yarn_version\"" >> "${layer_dir}.toml"

    curl -sL "$yarn_url" | tar xz --strip-components=1 -C "$layer_dir"
  fi
}
