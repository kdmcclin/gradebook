# A thin wrapper around Highline's choose
module Menu
  def self.select prompt, options, accessor
    chosen = choose do |menu|
      menu.prompt = "#{prompt.strip.colorize(:cyan)} #{'>'.colorize(:light_black)} "
      options.each { |option| menu.choice option.send(accessor) }
    end
    options.find { |option| option.send(accessor) == chosen }
  end
end
