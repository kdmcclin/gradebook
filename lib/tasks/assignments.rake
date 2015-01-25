namespace :assignments do

  desc 'Create a new assignment'
  task :new => :environment do
    puts "Creating a new assignment"

    path  = ask "Path to Markdown file (org/repo/path) >" do |q|
      q.validate = /\w+/
    end
    raw   = Assignment.raw_url path
    fetch = HTTParty.get raw
    unless fetch.ok?
      puts "Failed to fetch '#{raw}' (#{fetch.code}). Is it valid?".colorize :red
      exit 1
    end

    due_day = ask "Due day > ", Date do |q|
      q.default = 1.day.from_now.strftime '%b %d'
    end
    due_time = ask "Due time > ", Time do |q|
      q.default = "9:00"
    end
    due_at = DateTime.new due_day.year, due_day.month, due_day.day,
                          due_time.hour, due_time.min, due_time.sec, due_time.zone

    assignment = Assignment.where(path: path, due_at: due_at).first_or_create!

    team = Menu.select "Assign to team", Team.all, :title
    team.assign! assignment
  end


  desc 'Check for completed assignments'
  task :check => :environment do
    existing = Solution.complete
    Solution.find_each &:check!
    recent = Solution.complete - existing

    if recent.any?
      puts "Added #{recent.count} new solutions"
    else
      puts "No new solutions found"
      exit
    end

    choose do |menu|
      menu.prompt = "What would you like to do? > "

      menu.choice "List solutions" do
        puts
        recent.each { |solution| puts solution.html_url }
      end

      menu.choice "Review solutions" do
        recent.each { |solution| `open #{solution.html_url}` }
      end

      menu.choice "Nothing"
    end
  end

  desc "Produce a CSV containing solution information"
  task :report do
    # FIXME: should produce a CSV with solution submission times and links for each
    #   user on a given team
    raise NotImplementedError
  end

end
