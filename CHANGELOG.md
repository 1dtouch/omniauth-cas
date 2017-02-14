# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/)

## 1.1.4 - 2017-02-14

### Changed

* Require omniauth 1.5 minimum, to avoid error message about variable name conflicts
* Allow url, login_url, logout_url and service_validate_url to be lambdas in order to make the gem more flexible for different uses
* Handle blank xml nodes in CAS response, treating them as empty
* Add a bibid key to the auth schema keys

## 1.1.1 - 2016-09-19

### Changed

* Relax gemspec requirements, to add support for Rails 5.

Note that the only tested versions of Ruby are now 2.1, 2.2, and 2.3 - older
versions of Ruby should work, but are no longer officially supported.
