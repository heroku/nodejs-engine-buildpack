# Changelog
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## master
- Write bootstrapped binaries to a layer instead of to `bin`; Add a logging method for build output ([#34](https://github.com/heroku/nodejs-engine-buildpack/pull/34))

## 0.4.2 (2020-01-30)
### Added
- Added `provides` and `requires` of `node` to buildplan. ([#31](https://github.com/heroku/nodejs-engine-buildpack/pull/31))

## 0.4.1 (2019-11-08)
### Fixed
- Fix updates to `nodejs.toml` when layer contents not updated ([#27](https://github.com/heroku/nodejs-engine-buildpack/pull/27))

## 0.4.0 (2019-10-31)
### Added
- Add launch.toml support to engine ([#26](https://github.com/heroku/nodejs-engine-buildpack/pull/26))
- Parse engines and add them to nodejs.toml ([#25](https://github.com/heroku/nodejs-engine-buildpack/pull/25))
- Add shellcheck to test suite ([#24](https://github.com/heroku/nodejs-engine-buildpack/pull/24))
