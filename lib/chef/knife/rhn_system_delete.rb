#
# Author:: Brian Flad (<bflad@wharton.upenn.edu>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/rhn_base'

class Chef
  class Knife
    class RhnSystemDelete < Knife

      include Knife::RhnBase

      banner "knife rhn system delete SYSTEM (options)"
      category "rhn"

      # Until released: https://github.com/duritong/ruby-rhn_satellite/pull/5
      module System
        def delete(system_id)
          base.default_call('system.deleteSystems',[system_id.to_i])
        end
      end

      def run
        $stdout.sync = true
        
        system = name_args.first

        if system.nil?
          ui.fatal "You need a system name!"
          show_usage
          exit 1
        end

        set_rhn_connection_options

        satellite_system = get_satellite_system(system)

        RhnSatellite::System.extend(System)
        RhnSatellite::System.delete(satellite_system['id'])
        ui.info "Deleted RHN System: #{satellite_system['name']} (ID: #{satellite_system['id']})"
      end

    end
  end
end