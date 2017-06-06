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

For use of a basic proxy, use "proxy_address" and "proxy_port":
```
{
  "statuspage": {
    "api_key": "YOURAPIKEY",
    "page_id": "YOURPAGEID",
    "proxy_port": "YOURPROXY",
    "proxy_address": "YOURPROXYADDRESS"
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

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes

As of this writing Redphone has not added StatusPage.io support to v0.0.6
You must manually build and install the gem:
```
git clone https://github.com/portertech/redphone.git
cd redphone
gem build redphone.gemspec  OR  /opt/sensu/embedded/bin/gem build redphone.gemspec
gem install redphone-0.0.6.gem  OR  /opt/sensu/embedded/bin/gem install redphone-0.0.6.gem
```

To update a component add a `"component_id": "IDHERE"` attribute to the corresponding check definition

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

To choose your own component or incident statuses instead of the defaults add the `statuspage_<component/incident>_<status>` in the check definition.

Example:
```
{
  "checks": {
    "check_sshd": {
      "handlers": ["statuspage"],
      "component_id": "IDHERE",
      "statuspage_component_warning": "degraded_performance",
      "statuspage_component_critical": "partial_outage",
      "statuspage_incident_warning": "ignore",
      "statuspage_incident_critical": "identified",
      "command": "/etc/sensu/plugins/check-procs.rb -p sshd -C 1 ",
      "interval": 60,
      "subscribers": [ "default" ]
    }
  }
}
```
