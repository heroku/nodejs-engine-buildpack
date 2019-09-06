set -eu
set -o pipefail

source "./lib/build.sh"

layers_dir=$(mktemp -u -t build_shpec_XXXXX)

describe "lib"
  describe "bootstrap_buildpack"
    # stub_command "bash"

    it "runs when there's no binaries"
    end

    it "does not runs when there's binaries"
    end

    # unstub_command "bash"
  end

  describe "install_or_reuse_parse_tools"
    # stub_command wget

    # it "creates a bin layer"
    #   install_or_reuse_parse_tools "$layers_dir/bin"
    #   echo $layers_dir
    # end

    it "creates a bin.toml"
      install_or_reuse_parse_tools "$layers_dir/bin"
      assert file_present "$layers_dir/bin.toml"
    end
  end

  describe "create_bin_layer"
end
