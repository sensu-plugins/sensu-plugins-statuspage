# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

## [1.1.0] - 2017-06
### Added
- handler-statuspage.rb: add ability to send requests through an unauthenticated proxy (@drhey)

## [1.0.0] - 2017-05-16
### Added
- Support for Ruby 2.3 and 2.4 (@eheydrick)

### Removed
- Support for Ruby < 2 (@eheydrick)

### Changed
- Allow desired component/incident status configuration per check. (@athal7)
- Update existing incidents on any change, not just on resolution.  (@athal7)
- 'minor' alerts are now mapped to 'partial_outage' component status (@athal7)
- All alerts make the incident status 'identified' rather than 'investigating' (@athal7)

## [0.0.3] - 2015-12-30
### Changed
- fixed incident resolving

## [0.0.2] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## 0.0.1 - 2015-07-04
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-statuspage/compare/1.1.0...HEAD
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-statuspage/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-statuspage/compare/0.0.3...1.0.0
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-statuspage/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-statuspage/compare/0.0.1...0.0.2
