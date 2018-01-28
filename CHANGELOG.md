# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixes
- Fix links in this changelog
- Fix repo being added with `undef` URL by default on Debian/Ubuntu.

## Version [1.0.1] - 2018-01-28
### Summary
This version contains some minor documentation fixes only

### Fixes
- Fix links in this changelog

## Version [1.0.0] - 2018-01-28
### Summary
First stable release. This version now requires Puppet 4.9 or greater.

### Added
- FreeBSD support (no repo management)

### Changed
- Large refactoring to adhere to standard module layout
- `$packages_install` has been renamed to `$package_manage`
- Minimum required Puppet version is now 4.9
- Several style/lint related changes

## Version [0.2.1] - 2017-07-31
### Summary

First public release. This version is used by the author on a production system.

### Fixes
- Fixes several style/lint related issues

## Version [0.2.0] - 2017-07-31
### Summary

This version removes `rmilter` support in favor of the `rspamd_proxy` [milter support](https://rspamd.com/doc/workers/rspamd_proxy.html) added in Rspamd 1.6

## Version 0.1.0 (unreleased)
### Summary

Initial development, was not used or tested on a production system

[Unreleased]: https://github.com/oxc/puppet-rspamd/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/oxc/puppet-rspamd/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/oxc/puppet-rspamd/compare/v0.2.1...v1.0.0
[0.2.1]: https://github.com/oxc/puppet-rspamd/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/oxc/puppet-rspamd/compare/1980687...v0.2.0
