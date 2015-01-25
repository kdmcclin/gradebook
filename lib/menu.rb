# A thin wrapper around Highline's choose
module Menu
  def self.select prompt, options, accessor, optional: false, default: nil
    chosen = choose do |menu|
      menu.prompt = "#{prompt.strip.colorize(:cyan)} #{'>'.colorize(:light_black)} "
      options.each { |option| menu.choice option.send(accessor) }
      menu.choice 'None' if optional

      if default
        default = default.send accessor
        menu.prompt += "|#{default}| "
        menu.default = default
      end
    end
    options.find { |option| option.send(accessor) == chosen }
  end
end
