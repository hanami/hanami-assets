# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Break Versioning](https://www.taoensso.com/break-versioning).

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

[Unreleased]: https://github.com/hanami/assets/compare/v2.3.0...HEAD

## [2.3.0] - 2025-11-12

[2.3.0]: https://github.com/hanami/assets/compare/v2.3.0.beta2...v2.3.0

## [2.3.0.beta2] - 2025-10-17

### Changed

- Drop support for Ruby 3.1.

[2.3.0.beta2]: https://github.com/hanami/assets/compare/v2.3.0.beta1...v2.3.0.beta2

## [2.3.0.beta1] - 2025-10-03

[2.3.0.beta1]: https://github.com/hanami/assets/compare/v2.2.0...v2.3.0.beta1

## [2.2.0] - 2024-11-05

[2.2.0]: https://github.com/hanami/assets/compare/v2.2.0.rc1...v2.2.0

## [2.2.0.rc1] - 2024-10-29

[2.2.0.rc1]: https://github.com/hanami/assets/compare/v2.2.0.beta2...v2.2.0.rc1

## [2.2.0.beta2] - 2024-09-25

[2.2.0.beta2]: https://github.com/hanami/assets/compare/v2.2.0.beta1...v2.2.0.beta2

## [2.2.0.beta1] - 2024-07-16

### Changed

- Drop support for Ruby 3.0.

[2.2.0.beta1]: https://github.com/hanami/assets/compare/v2.1.0...v2.2.0.beta1

## [2.1.0] - 2024-02-27

[2.1.0]: https://github.com/hanami/assets/compare/v2.1.0.rc3...v2.1.0

## [2.1.0.rc3] - 2024-02-16

### Changed

- Require a `root:` argument when initializing `Hanami::Assets`. This should be the directory containing the compiled assets and their `assets.json` manifest file. (Tim Riley)
- Removed `manifest_path` setting; the manifest path is no longer user-configurable. (Tim Riley)
- Replaced `package_manager_run_command` setting with `node_command` setting. (Tim Riley)
- Removed unused `sources`, `entry_point_patterns` and `destination` settings. (Tim Riley)
- Removed `bin/hanami-assets` executable. (Tim Riley)

[2.1.0.rc3]: https://github.com/hanami/assets/compare/v2.1.0.rc2...v2.1.0.rc3

## [2.1.0.rc2] - 2023-11-08

[2.1.0.rc2]: https://github.com/hanami/assets/compare/v2.1.0.rc1...v2.1.0.rc2

## [2.1.0.rc1] - 2023-11-01

[2.1.0.rc1]: https://github.com/hanami/assets/compare/v2.1.0.beta2...v2.1.0.rc1

## [2.1.0.beta2] - 2023-10-04

### Added

- Official support for Ruby: Ruby 3.1, and 3.2. (Luca Guidi)

### Changed

- Drop support for Ruby: MRI 2 and JRuby. (Luca Guidi)
- This gem now requires a working Node and Yarn installation. (Luca Guidi)
- Changed the gem to load using Zeitwerk, via `require "hanami/assets"`. (Tim Riley)
- Changed `Hanami::Assets` to a class, initialized with a `Hanami::Assets::Config` (see below) and providing a `#[]` method returning a `Hanami::Assets::Asset` instance per asset. (Tim Riley)
- Moved `Hanami::Assets::Helpers` to `Hanami::Helpers::AssetsHelper` in the hanami gem (along with various helper methods renamed; see the hanami CHANGELOG for details). (Tim Riley)
- Renamed `Hanami::Assets::Configuration` to `Config`. (Luca Guidi)
- Removed `Hanami::Assets.configure`, use `Hanami::Assets::Config.new`. (Luca Guidi)
- Removed `Hanami::Assets.deploy`, `.precompile`, `.load!` as precompile process is now handled via JavaScript. (Luca Guidi)
- Removed `Hanami::Assets.sources`, as third-party libraries should be handled via Yarn. (Luca Guidi)
- Removed `Hanami::Assets::Config#fingerprint`, as fingerprinting will be always activated. (Luca Guidi)
- Changed `Hanami::Assets::Config#subresource_integrity`. To activate the feature, pass an array of algorithms to use (e.g. `config.subresource_integrity = ["sha-384"]`). (Luca Guidi)
- Removed `Hanami::Assets::Config#cdn`. To activate the feature, pass the CDN base URL to the initializer of the configuration (`base_url` keyword argument). (Luca Guidi)
- Removed `Hanami::Assets::Config#javascript_compressor` and `stylesheet_compressor`, as the compression is now handled via JavaScript. (Luca Guidi)
- Removed `Hanami::Assets::Config#scheme`, `#host`, `#port`, and `#prefix`. Use `base_url` keyword argument to pass to configuration initializer. (Luca Guidi)
- Removed `Hanami::Assets::Config#root`, `#public_directory`, `#destination_directory`, and `#manifest` as they will now looked up via conventions. (Luca Guidi)
- Moved `Hanami::Assets::Precompiler` and `Watcher` to `hanami-cli`. (Luca Guidi)

[2.1.0.beta2]: https://github.com/hanami/assets/compare/v1.3.5...v2.1.0.beta2

## [1.3.5] - 2021-01-14

### Added

- Official support for Ruby: MRI 3.0. (Luca Guidi)
- Official support for Ruby: MRI 2.7. (Luca Guidi)

[1.3.5]: https://github.com/hanami/assets/compare/v1.3.4...v1.3.5

## [1.3.4] - 2019-10-11

### Fixed

- Precompile assets using binary mode to ensure compatibility with Windows. (unleashy)

[1.3.4]: https://github.com/hanami/assets/compare/v1.3.3...v1.3.4

## [1.3.3] - 2019-09-13

### Fixed

- Lazily load `sassc` only when required. (Landon Grindheim)
- Ensure assets precompilation to not crash when SASS stylesheet doesn't have dependencies. (Landon Grindheim)

[1.3.3]: https://github.com/hanami/assets/compare/v1.3.2...v1.3.3

## [1.3.2] - 2019-08-02

### Added

- Added support for `sassc` gem, because `sass` is no longer maintained. (Landon Grindheim & Sean Collins)

[1.3.2]: https://github.com/hanami/assets/compare/v1.3.1...v1.3.2

## [1.3.1] - 2019-01-18

### Added

- Official support for Ruby: MRI 2.6. (Luca Guidi)
- Support `bundler` 2.0+. (Luca Guidi)

### Fixed

- Make optional nested assets feature to maintain backward compatibility with `1.2.x`. (Luca Guidi)

[1.3.1]: https://github.com/hanami/assets/compare/v1.3.0...v1.3.1

## [1.3.0] - 2018-10-24

[1.3.0]: https://github.com/hanami/assets/compare/v1.3.0.beta1...v1.3.0

## [1.3.0.beta1] - 2018-08-08

### Added

- Preserve directory structure of assets at the precompile time. (Paweł Świątkowski)
- Official support for JRuby 9.2.0.0. (Luca Guidi)

[1.3.0.beta1]: https://github.com/hanami/assets/compare/v1.2.0...v1.3.0.beta1

## [1.2.0] - 2018-04-11

[1.2.0]: https://github.com/hanami/assets/compare/v1.2.0.rc2...v1.2.0

## [1.2.0.rc2] - 2018-04-06

[1.2.0.rc2]: https://github.com/hanami/assets/compare/v1.2.0.rc1...v1.2.0.rc2

## [1.2.0.rc1] - 2018-03-30

[1.2.0.rc1]: https://github.com/hanami/assets/compare/v1.2.0.beta2...v1.2.0.rc1

## [1.2.0.beta2] - 2018-03-23

[1.2.0.beta2]: https://github.com/hanami/assets/compare/v1.2.0.beta1...v1.2.0.beta2

## [1.2.0.beta1] - 2018-02-28

### Added

- Collect assets informations for Early Hints (103). (Luca Guidi)
- Send automatically javascripts and stylesheets via Push Promise / Early Hints. (Luca Guidi)
- Add the ability to send audio, video, and generic assets for Push Promise / Early Hints. (Luca Guidi)

[1.2.0.beta1]: https://github.com/hanami/assets/compare/v1.1.1...v1.2.0.beta1

## [1.1.1] - 2018-02-27

### Added

- Official support for Ruby: MRI 2.5. (Luca Guidi)

### Fixed

- Print `href` and `src` first in output HTML. (Malina Sulca)

[1.1.1]: https://github.com/hanami/assets/compare/v1.1.0...v1.1.1

## [1.1.0] - 2017-10-25

### Fixed

- Don't let `#javascript` and `#stylesheet` helpers to append file extension if the URL contains a query string. (Luca Guidi)

[1.1.0]: https://github.com/hanami/assets/compare/v1.1.0.rc1...v1.1.0

## [1.1.0.rc1] - 2017-10-16

[1.1.0.rc1]: https://github.com/hanami/assets/compare/v1.1.0.beta3...v1.1.0.rc1

## [1.1.0.beta3] - 2017-10-04

[1.1.0.beta3]: https://github.com/hanami/assets/compare/v1.1.0.beta2...v1.1.0.beta3

## [1.1.0.beta2] - 2017-10-03

[1.1.0.beta2]: https://github.com/hanami/assets/compare/v1.1.0.beta1...v1.1.0.beta2

## [1.1.0.beta1] - 2017-08-11

[1.1.0.beta1]: https://github.com/hanami/assets/compare/v1.0.0...v1.1.0.beta1

## [1.0.0] - 2017-04-06

[1.0.0]: https://github.com/hanami/assets/compare/v1.0.0.rc1...v1.0.0

## [1.0.0.rc1] - 2017-03-31

[1.0.0.rc1]: https://github.com/hanami/assets/compare/v1.0.0.beta2...v1.0.0.rc1

## [1.0.0.beta2] - 2017-03-17

[1.0.0.beta2]: https://github.com/hanami/assets/compare/v1.0.0.beta1...v1.0.0.beta2

## [1.0.0.beta1] - 2017-02-14

### Added

- Official support for Ruby: MRI 2.4. (Luca Guidi)

[1.0.0.beta1]: https://github.com/hanami/assets/compare/v0.4.0...v1.0.0.beta1

## [0.4.0] - 2016-11-15

### Changed

- Official support for Ruby: MRI 2.3+ and JRuby 9.1.5.0+. (Luca Guidi)
- Rename digest into fingerprint. (Sean Collins)

### Fixed

- Ensure `NullManifest` to be pretty printable. (Luca Guidi)

[0.4.0]: https://github.com/hanami/assets/compare/v0.3.0...v0.4.0

## [0.3.0] - 2016-07-22

### Added

- Subresource Integrity (SRI). (Matthew Gibbons & Sean Collins)
- Allow `javascript` and `stylesheet` helpers to accept a Hash representing HTML attributes. Eg. `<%= javascript 'application', async: true %>`. (Matthew Gibbons & Sean Collins)

### Changed

- Drop support for Ruby 2.0 and 2.1. Official support for JRuby 9.0.5.0+. (Luca Guidi)
- Don't create digest version of files under public directory, but only for precompiled files. (Luca Guidi)

### Fixed

- Safely precompile assets from directories with a dot in their name. (Alexander Gräfe)
- Detect changes for Sass/SCSS dependencies. (Luca Guidi)
- Preserve static assets under public directory, by removing only assets directory and manifest at the precompile time. (Maxim Dorofienko & Luca Guidi)

[0.3.0]: https://github.com/hanami/assets/compare/v0.2.1...v0.3.0

## [0.2.1] - 2016-02-05

### Changed

- Don't precompile `.map` files. (Derk-Jan Karrenbeld)

### Fixed

- Fix recursive Sass imports. (Luca Guidi)
- Ensure to truncate assets in public before to precompile/copy them. (Luca Guidi)

[0.2.1]: https://github.com/hanami/assets/compare/v0.2.0...v0.2.1

## [0.2.0] - 2016-01-22

### Changed

- Renamed the project. (Luca Guidi)

[0.2.0]: https://github.com/hanami/assets/compare/v0.1.0...v0.2.0

## 0.1.0 - 2016-01-12

### Added

- Configurable assets compressors. (Luca Guidi)
- Builtin JavaScript and stylesheet compressors. (Luca Guidi)
- Added `Lotus::Assets::Helpers#favicon`. (deepj & Michael Deol)
- Added `Lotus::Assets::Helpers#video`. (Leigh Halliday)
- Added `Lotus::Assets::Helpers#audio`. (Kleber Correia)
- Added `Lotus::Assets::Helpers#image`. (Gonzalo Rodríguez-Baltanás Díaz)
- Added `Lotus::Assets::Helpers#javascript` and `#stylesheet`. (Luca Guidi)
- Added `Lotus::Assets::Helpers#asset_path` and `#asset_url`. (Luca Guidi)
- "CDN Mode" let helpers to generate CDN URLs (eg. `https://123.cloudfront.net/assets/application-d1829dc353b734e3adc24855693b70f9.js`). (Luca Guidi)
- "Digest Mode" let helpers to generate digest URLs (eg. `/assets/application-d1829dc353b734e3adc24855693b70f9.js`). (Luca Guidi)
- Added `hanami-assets` command to precompile assets at the deploy time. (Luca Guidi)
- Added support for third party gems that want to ship gemified assets for Lotus. (Luca Guidi)
- Assets preprocessors (eg. Sass, ES6, CoffeeScript, Opal, JSX). (Luca Guidi)
- Official support for Ruby 2.0+. (Luca Guidi)
