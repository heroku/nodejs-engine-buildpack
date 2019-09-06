.EXPORT_ALL_VARIABLES:

.PHONY: test \
        build \
        clean \
        package \
        release

SHELL=/bin/bash -o pipefail

GO111MODULE := on

VERSION := "v$$(cat buildpack.toml | grep version | sed -e 's/version = //g' | xargs)"

test:
	make unit-test && make binary-test

unit-test:
	shpec ./shpec/*/*.sh

binary-test:
	-docker rm -f node-js-cnb-test
	@docker create --name node-js-cnb-test --workdir /app golang:1.12.9 bash -c "go test ./... -tags=integration"
	@docker cp . node-js-cnb-test:/app
	@docker start -a node-js-cnb-test

build:
	@GOOS=linux go build -o "bin/resolve-version" ./cmd/resolve-version/...

clean:
	-rm -f node-js-cnb-$(VERSION).tgz
	-rm -f bin/resolve-version

package: clean build
	@tar cvzf node-js-cnb-$(VERSION).tgz bin/ buildpack.toml README.md

release:
	@git tag $(VERSION)
	@git push --tags origin master

shellcheck:
	@shellcheck -x bin/bootstrap bin/build bin/detect
	@shellcheck -x bin/utils/**
