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
	make shellcheck
	make binary-test
	make docker-unit-test

unit-test-heroku-20:
	@docker run -v $(PWD):/project danielleadams/shpec-heroku-20:0.0.4

unit-test-heroku-18:
	@docker run -v $(PWD):/project danielleadams/shpec-heroku-18:0.0.4

unit-test-heroku-16:
	@docker run -v $(PWD):/project danielleadams/shpec-heroku-16:0.0.4

docker-unit-test:
	@docker run -v $(PWD):/project danielleadams/shpec:latest

unit-test:
	shpec ./shpec/*_shpec.sh

binary-test:
	-docker rm -f nodejs-engine-buildpack-test
	@docker create --name nodejs-engine-buildpack-test --workdir /app golang:1.14 bash -c "go test ./... -tags=integration"
	@docker cp . nodejs-engine-buildpack-test:/app
	@docker start -a nodejs-engine-buildpack-test

build:
	@GOOS=linux go build -o "bin/resolve-version" ./cmd/resolve-version/...

build-local:
	@GOOS=darwin go build -o "bin/resolve-version" ./cmd/resolve-version/...

clean:
	-rm -f nodejs-engine-buildpack-$(VERSION).tgz
	-rm -f bin/resolve-version

package: clean build
	@tar cvzf nodejs-engine-buildpack-$(VERSION).tgz bin/ lib/** buildpack.toml README.md

release:
	@git tag $(VERSION)
	@git push --tags origin master

shellcheck:
	@shellcheck -x bin/build bin/detect
	@shellcheck -x lib/*.sh lib/utils/*.sh shpec/*.sh
