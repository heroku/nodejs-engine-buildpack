set -e
set -o pipefail

source "./lib/build.sh"

create_temp_layer_dir() {
  mktemp -u -t build_shpec_XXXXX
}

describe "lib/build.sh"
  describe "install_or_reuse_parse_tools"
    layers_dir=$(create_temp_layer_dir)

    it "creates a bin layer"
      install_or_reuse_parse_tools "$layers_dir/bin"

      assert file_present "$layers_dir/bin/jq"
      assert file_present "$layers_dir/bin/yj"
    end

    it "creates a bin.toml"
      install_or_reuse_parse_tools "$layers_dir/bin"

      assert file_present "$layers_dir/bin.toml"
    end
  end

  describe "install_or_reuse_node"
    layers_dir=$(create_temp_layer_dir)
    bootstrap_buildpack
    export PATH=$bp_dir/bin:$PATH

    it "creates a node layer when it does not exist"
      assert file_absent "$layers_dir/nodejs/bin/node"
      assert file_absent "$layers_dir/nodejs/bin/npm"

      install_or_reuse_node "$layers_dir/nodejs"

      assert file_present "$layers_dir/nodejs/bin/node"
      assert file_present "$layers_dir/nodejs/bin/npm"
    end

    it "reuses node layer when versions match"
      # TODO: set up fixtures for version matching
    end
  end

  describe "install_or_reuse_yarn"
    layers_dir=$(create_temp_layer_dir)
    bootstrap_buildpack
    export PATH=$bp_dir/bin:$PATH

    it "creates a yarn layer when it does not exist"
      assert file_absent "$layers_dir/yarn/bin/yarn"

      install_or_reuse_yarn "$layers_dir/yarn"

      assert file_present "$layers_dir/yarn/bin/yarn"
    end

    it "reuses yarn layer when versions match"
      # TODO: set up fixtures for version matching
    end
  end
end
