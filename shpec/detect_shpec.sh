set -e
set -o pipefail

source "./lib/detect.sh"

describe "lib/detect.sh"
  describe "detect_package_json"
    it "exits with 100 if there is no package.json"
      rm ./package.json

      detect_package_json > /dev/null 2>& 1
      assert equal "$?" 100
    end

    it "exits with 0 if there is package.json"
      touch ./package.json
      detect_package_json

      assert equal "$?" 0
      rm ./package.json
    end
  end
end
