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
end
