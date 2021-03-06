#
# Author:: Brian Flad (<bflad@wharton.upenn.edu>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/rhn_base'

class Chef
  class Knife
    class RhnSystemgroupActive < Knife

      include Knife::RhnBase

      banner "knife rhn systemgroup active GROUP (options)"
      category "rhn"


      # Until released: https://github.com/duritong/ruby-rhn_satellite/pull/7
      module Systemgroup
        def active_systems(group_name)
          base.default_call('systemgroup.listActiveSystemsInGroup',group_name)
        end
      end

      def run
        $stdout.sync = true
        
        group = name_args.first

        if group.nil?
          ui.fatal "You need a systemgroup name!"
          show_usage
          exit 1
        end

        set_rhn_connection_options

        RhnSatellite::Systemgroup.extend(Systemgroup)
        system_ids = RhnSatellite::Systemgroup.active_systems(group)
        systems = []
        system_ids.each do |system_id|
          systems << RhnSatellite::System.details(system_id)
        end
        systems.sort! {|a,b| a['profile_name'] <=> b['profile_name']}
        systems.each do |system|
          ui.info "#{system['id']},#{system['profile_name']}"
        end
      end
      
    end
  end
end
