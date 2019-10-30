set -e
set -o pipefail

source "./lib/utils/json.sh"
source "./lib/utils/toml.sh"
source "./lib/build.sh"

create_temp_layer_dir() {
  mktemp -d -t build_shpec_XXXXX
}

create_temp_project_dir() {
  mktemp -u -t project_shpec_XXXXX
}

create_temp_package_json() {
  mkdir -p "tmp"
  cp "./fixtures/package-fixed-versions.json" "tmp/package.json"
}

rm_temp_dirs() {
  rm -rf $1
  rm -rf "tmp"
}

create_binaries() {
  stub_command "echo"
  bootstrap_buildpack
  unstub_command "echo"
}

rm_binaries() {
  rm -f $bp_dir/bin/resolve-version
}

describe "lib/build.sh"
  rm_binaries
  create_binaries
  export PATH=$bp_dir/bin:$PATH

  describe "install_or_reuse_toolbox"
    layers_dir=$(create_temp_layer_dir)
    project_dir=$(create_temp_project_dir)

    it "creates a toolbox layer"
      install_or_reuse_toolbox "$layers_dir/toolbox" $project_dir

      assert file_present "$layers_dir/toolbox/bin/jq"
      assert file_present "$layers_dir/toolbox/bin/yj"
    end

    it "creates a toolbox.toml"
      install_or_reuse_toolbox "$layers_dir/toolbox" $project_dir

      assert file_present "$layers_dir/toolbox.toml"
    end
  end

  describe "install_or_reuse_node"
    layers_dir=$(create_temp_layer_dir)

    it "creates a node layer when it does not exist"
      assert file_absent "$layers_dir/nodejs/bin/node"
      assert file_absent "$layers_dir/nodejs/bin/npm"

      install_or_reuse_node "$layers_dir/nodejs" $project_dir

      assert file_present "$layers_dir/nodejs/bin/node"
      assert file_present "$layers_dir/nodejs/bin/npm"
    end

    it "reuses node layer when versions match"
      # TODO: set up fixtures for version matching
    end
  end

  describe "parse_package_json_engines"
    layers_dir=$(create_temp_layer_dir)

    # prepare layers
    touch "${layers_dir}/nodejs.toml"
    create_temp_package_json

    parse_package_json_engines "$layers_dir/nodejs" "tmp"

    it "writes npm version to layers/node.toml"
      local npm_version=$(toml_get_key_from_metadata "$layers_dir/nodejs.toml" "npm_version")

      assert equal "6.9.1" "$npm_version"
    end

    it "writes yarn_version to layers/node.toml"
      local yarn_version=$(toml_get_key_from_metadata "$layers_dir/nodejs.toml" "yarn_version")

      assert equal "1.19.1" "$yarn_version"
    end

    rm_temp_dirs "$layers_dir"
  end

  describe "install_or_reuse_yarn"
    layers_dir=$(create_temp_layer_dir)
    export PATH=$bp_dir/bin:$PATH

    it "creates a yarn layer when it does not exist"
      assert file_absent "$layers_dir/yarn/bin/yarn"

      install_or_reuse_yarn "$layers_dir/yarn" "$project_dir"

      assert file_present "$layers_dir/yarn/bin/yarn"
    end

    it "reuses yarn layer when versions match"
      # TODO: set up fixtures for version matching
    end

    rm_temp_dirs "$layers_dir"
  end

  rm_binaries
end
