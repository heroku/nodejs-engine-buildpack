set -e
set -o pipefail

source "./lib/detect.sh"

describe "lib/detect.sh"
  describe "detect_package_json"
    it "exits with 1 if there is no package.json"
      rm -f ./package.json
      set +e
      detect_package_json
      loc_var=$?
      set -e
      assert equal $loc_var 1
    end

    it "exits with 0 if there is package.json"
      touch ./package.json
      detect_package_json

      assert equal "$?" 0
      rm ./package.json
    end
  end
end
