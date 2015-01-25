module ApplicationHelper
  def self.format_datetime dt
    # TODO: make this more flexible
    dt.in_time_zone("EST").strftime "%b %d @ %I:%M%P"
  end

  def format_datetime dt
    # :shipit:
    ApplicationHelper.format_datetime dt
  end

  def checked_age assignment
    if assignment.checked_at
      "#{time_ago_in_words assignment.checked_at} ago"
    else
      "Never been checked"
    end
  end

  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end

  def flash_class name
    # Translate rails conventions to bootstrap conventions
    case name.to_sym
    when :notice
      :success
    when :alert
      :danger
    else
      name
    end
  end
end
