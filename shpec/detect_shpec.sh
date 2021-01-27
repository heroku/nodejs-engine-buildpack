#!/usr/bin/env bash

set -e
set -o pipefail

source "./lib/detect.sh"

create_temp_project_dir() {
  mktemp -dt project_shpec_XXXXX
}

describe "lib/detect.sh"
  describe "write_to_build_plan"
    it "writes node for [[provides]] and [[requires]]"
      project_dir=$(create_temp_project_dir)
      touch "$project_dir/buildplan.toml"
      write_to_build_plan "$project_dir/buildplan.toml"
      actual=$(cat "$project_dir/buildplan.toml")
      echo "$actual"
      expected=$(cat <<EOF
  [[provides]]
  name = "node"

  [[requires]]
  name = "node"
EOF
)
      assert equal "$actual" "$expected"
    end
  end
end
