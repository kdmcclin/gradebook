module ApplicationHelper
  def self.format_datetime dt
    # TODO: make this more flexible
    dt.in_time_zone("EST").strftime "%b %d @ %H:%M"
  end
end
