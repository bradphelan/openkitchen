module OpenKitchen
  class TimeZone
    # Returns a hash with javascript compatible timezone
    # offset  as key.
    def self.timezones_by_offset
      @timezone_by_offset = {}
      ActiveSupport::TimeZone.all.each do |tz|
        unless @timezone_by_offset.has_key? tz.utc_offset
          @timezone_by_offset[tz.utc_offset/60] = tz.name
        end
      end
      @timezone_by_offset
    end
  end
end
