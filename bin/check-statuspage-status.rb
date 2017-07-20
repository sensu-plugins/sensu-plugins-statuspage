#! /usr/bin/env ruby
#
# check-statuspage-status
#
# DESCRIPTION:
#   This is a simple check for the status rollup of a StatusPage instance.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# USAGE:
#   check-statuspage-status -u https://metastatuspage.com
#
# Depends on httparty gem
#   gem install httparty
#
# LICENSE:
# Paul Bailey <https://github.com/spacepants>
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/check/cli'
require 'httparty'
require 'json'

class CheckStatusPageStatus < Sensu::Plugin::Check::CLI
  option :url,
         description: 'URL',
         short: '-u URL',
         long: '--url URL',
         required: true

  def get(url)
    response = HTTParty.get(url, format: :plain)
    JSON.parse response, symbolize_names: true
  rescue HTTParty::Error
    critical 'HTTParty error'
  rescue JSON::ParserError
    critical 'Invalid JSON'
  rescue StandardError
    critical 'Connection error'
  end

  def run
    resource = get("#{config[:url]}/api/v2/status.json")
    status = resource[:status]
    case status[:indicator]
    when 'critical'
      critical status[:description]
    when 'major', 'minor'
      warning status[:description]
    when 'none'
      ok status[:description]
    else
      unknown status[:description]
    end
  end
end
