require 'highline/import'

namespace :users do
  desc 'Populate users from a GitHub organization'
  task :populate => :environment do
    puts "Populating users from GitHub".colorize :light_green

    org = Menu.select "Which org?", Organization.all, :login

    puts
    puts "Adding members for #{org.name.colorize :light_green}"

    org.load_teams!
    org.teams.each do |team|
      puts "#{team.name} has #{team.members.count} members"
    end
  end

  desc 'Randomize members on a specified team'
  task :shuffle => :environment do
    team = Menu.select "Which team?", Team.all, :title
    team.members.shuffle.each_with_index do |user, i|
      puts "#{i+1} #{'-'.colorize :light_black} #{user.name}"
    end
  end
end
