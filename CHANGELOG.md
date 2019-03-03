# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- $rspamd::config parameter to simplify usage from hiera out of the box ([#2]).

## Release [1.0.2] - 2018-01-28
This version fixes a regression introduced in 1.0.0 that caused a non-working
APT repo to be added on Debian/Ubuntu by default.

### Fixes
- Fix links in this changelog
- Fix repo being added with `undef` URL by default on Debian/Ubuntu.

## Release [1.0.1] - 2018-01-28
This version contains some minor documentation fixes only

### Fixes
- Fix links in this changelog

## Release [1.0.0] - 2018-01-28
First stable release. This version now requires Puppet 4.9 or greater.

### Added
- FreeBSD support (no repo management)

### Changed
- Large refactoring to adhere to standard module layout
- `$packages_install` has been renamed to `$package_manage`
- Minimum required Puppet version is now 4.9
- Several style/lint related changes

## Release [0.2.1] - 2017-07-31
First public release. This version is used by the author on a production system.

### Fixes
- Fixes several style/lint related issues

## Release [0.2.0] - 2017-07-31
This version removes `rmilter` support in favor of the `rspamd_proxy` [milter support](https://rspamd.com/doc/workers/rspamd_proxy.html) added in Rspamd 1.6

## Version 0.1.0 (unreleased)
Initial development, was not used or tested on a production system

[Unreleased]: https://github.com/oxc/puppet-rspamd/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/oxc/puppet-rspamd/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/oxc/puppet-rspamd/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/oxc/puppet-rspamd/compare/v0.2.1...v1.0.0
[0.2.1]: https://github.com/oxc/puppet-rspamd/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/oxc/puppet-rspamd/compare/1980687...v0.2.0
[#2]: https://github.com/oxc/puppet-rspamd/pull/2
