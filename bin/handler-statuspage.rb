#!/usr/bin/env ruby
#
# This handler creates and updates incidents and changes a component status (optional) for StatusPage.IO.
# Due to a bug with their API, please pair a Twitter account to your StatusPage even if you don't plan to tweet.
#
# Copyright 2011 Sonian, Inc <chefs@sonian.net>
# Copyright 2013 DISQUS, Inc.
# Updated by jfledvin with Basic Component Support 4/14/2015
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-handler'
require 'redphone/statuspage'

ALLOWED_COMPONENT_STATUSES = %w(operational degraded_performance partial_outage major_outage ignore).freeze
DEFAULT_COMPONENT_STATUSES = {
  'warning' => 'partial_outage',
  'critical' => 'major_outage'
}.freeze

ALLOWED_INCIDENT_STATUSES = %w(investigating identified monitoring resolved ignore).freeze
DEFAULT_INCIDENT_STATUSES = {
  'warning' => 'identified',
  'critical' => 'identified'
}.freeze

# main plugin class
class StatusPage < Sensu::Handler
  def incident_key
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def status_name
    case @event['check']['status']
    when 1
      'warning'
    when 2
      'critical'
    end
  end

  def component_status
    case @event['action']
    when 'create'
      desired_status = @event['check']["statuspage_component_#{status_name}"]
      if desired_status && ALLOWED_COMPONENT_STATUSES.include?(desired_status)
        desired_status
      else
        DEFAULT_COMPONENT_STATUSES[status_name]
      end
    when 'resolve'
      'operational'
    end
  end

  def incident_status
    case @event['action']
    when 'create'
      desired_status = @event['check']["statuspage_incident_#{status_name}"]
      if desired_status && ALLOWED_INCIDENT_STATUSES.include?(desired_status)
        desired_status
      else
        DEFAULT_INCIDENT_STATUSES[status_name]
      end
    when 'resolve'
      'resolved'
    end
  end

  def ignore_status?(status)
    ['ignore', nil].include?(status)
  end

  def description
    @event['notification'] || [@event['client']['name'], @event['check']['name'], @event['check']['output']].join(' : ')
  end

  def incident_message(status)
    if status == 'resolved'
      "Problem with #{incident_key} has been resolved."
    else
      "There has been a problem: #{description}."
    end
  end

  def handle
    statuspage = Redphone::Statuspage.new(
      page_id: settings['statuspage']['page_id'],
      api_key: settings['statuspage']['api_key'],
      proxy_address: settings['statuspage']['proxy_address'],
      proxy_port: settings['statuspage']['proxy_port']
    )
    begin
      timeout(3) do
        if @event['check'].key?('component_id')
          unless ignore_status?(component_status)
            statuspage.update_component(
              component_id: @event['check']['component_id'],
              status: component_status
            )
          end
        end
        existing_incident = statuspage.get_all_incidents.detect { |incident| incident['name'] == incident_key && incident['status'] != 'resolved' }
        response = if existing_incident
                     statuspage.update_incident(
                       name: incident_key,
                       wants_twitter_update: 'f',
                       status: incident_status,
                       incident_id: existing_incident['id'],
                       message: incident_message(incident_status)
                     )
                   elsif !ignore_status?(incident_status)
                     statuspage.create_realtime_incident(
                       name: incident_key,
                       status: incident_status,
                       wants_twitter_update: 'f',
                       message: incident_message(incident_status)
                     )
                   end
        if ignore_status?(incident_status) ||
           (response['status'] == incident_status && @event['action'] == 'create') ||
           (response['status'] == 'resolved'      && @event['action'] == 'resolve')

          puts 'statuspage -- ' + @event['action'].capitalize + 'd incident -- ' + incident_key
        else
          puts 'statuspage -- failed to ' + @event['action'] + ' incident -- ' + incident_key
        end
      end
    rescue Timeout::Error
      puts 'statuspage -- timed out while attempting to ' + @event['action'] + ' a incident -- ' + incident_key
    end
  end
end
