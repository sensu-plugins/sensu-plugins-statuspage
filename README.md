## Sensu-Plugins-statuspage

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-statuspage.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-statuspage)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-statuspage.svg)](http://badge.fury.io/rb/sensu-plugins-statuspage)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-statuspage/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-statuspage)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-statuspage/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-statuspage)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-statuspage.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-statuspage)

## Functionality

**handler-statuspage**

Creates an issue on StatusPage.io and (optionally) updates a component status.

**metrics-statuspageio**

Sends graphite-style metrics to statuspage.io, for displaying public metrics.  Note, this forks and is not meant for high-throughput.  Rather, it is meant for high-value, low-throughput metrics for display on status page.

## Files
 * bin/handler-statuspage
 * bin/metrics-statuspageio

## Usage

**handler-statuspage**
```
{
  "statuspage": {
    "api_key": "YOURAPIKEY",
    "page_id": "YOURPAGEID"
  }
}
```

**metrics-statuspageio**
```
{
    "metrics-statuspageio": {
        "api_key": "my_api_key",
        "page_id": "my_page_id",
        "metrics": {
            "some.metric.identifier": "my_metric_id",
            "another.metric.identifier": "another_metric_id"
        }
    }
}
```
## Installation

<<<<<<< HEAD
Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-statuspage -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-statuspage`

#### Bundler

Add *sensu-plugins-statuspage* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-statuspage' do
  options('--prerelease')
  version '0.0.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-statuspage' do
  options('--prerelease')
  version '0.0.1'
end
```
=======
[Installation and Setup](https://github.com/sensu-plugins/documentation/blob/master/user_docs/installation_instructions.md)
>>>>>>> update repo

## Notes
As of this writing Redphone has not added StatusPage.io support to v0.0.6
You must manually build and install the gem:
```
git clone https://github.com/portertech/redphone.git
cd redphone
gem build redphone.gemspec  OR  /opt/sensu/embedded/bin/gem build redphone.gemspec
gem install redphone-0.0.6.gem  OR  /opt/sensu/embedded/bin/gem install redphone-0.0.6.gem
```

To update a component add a ```"component_id": "IDHERE"``` attribute to the corresponding check definition

Example:
```
{
  "checks": {
    "check_sshd": {
      "handlers": ["statuspage"],
      "component_id": "IDHERE",
      "command": "/etc/sensu/plugins/check-procs.rb -p sshd -C 1 ",
      "interval": 60,
      "subscribers": [ "default" ]
    }
  }
}
```
