set -e
set -o pipefail

source "./lib/build.sh"

create_temp_layer_dir() {
  mktemp -u -t build_shpec_XXXXX
}

create_temp_project_dir() {
  mktemp -u -t project_shpec_XXXXX
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

  describe "install_or_reuse_toolbox"
    layers_dir=$(create_temp_layer_dir)
    project_dir=$(create_temp_project_dir)

    it "creates a bin layer"
      install_or_reuse_toolbox "$layers_dir/toolbox" $project_dir

      assert file_present "$layers_dir/toolbox/bin/jq"
      assert file_present "$layers_dir/toolbox/bin/yj"
    end

    it "creates a bin.toml"
      install_or_reuse_toolbox "$layers_dir/toolbox" $project_dir

      assert file_present "$layers_dir/toolbox.toml"
    end
  end

  describe "install_or_reuse_node"
    layers_dir=$(create_temp_layer_dir)
    export PATH=$bp_dir/bin:$PATH

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

  describe "install_or_reuse_yarn"
    layers_dir=$(create_temp_layer_dir)
    export PATH=$bp_dir/bin:$PATH

    it "creates a yarn layer when it does not exist"
      assert file_absent "$layers_dir/yarn/bin/yarn"

      install_or_reuse_yarn "$layers_dir/yarn" $project_dir

      assert file_present "$layers_dir/yarn/bin/yarn"
    end

    it "reuses yarn layer when versions match"
      # TODO: set up fixtures for version matching
    end
  end

  rm_binaries
end
