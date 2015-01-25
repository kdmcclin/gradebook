require 'highline/import'

namespace :users do
  desc 'Populate users from a GitHub organization'
  task :populate => :environment do
    puts "Populating users from GitHub".colorize :light_green

    orgs = $octoclient.user.rels[:organizations].get
    org  = Menu.select "Which org?", orgs.data.reverse, :login

    puts
    puts "Adding members for #{org.login.colorize :light_green}"

    $octoclient.organization_teams(org.login).each do |team_data|
      team = Team.where(
        organization:    org.login,
        organization_id: org.id,
        name:            team_data.name,
        team_id:         team_data.id
      ).first_or_create!

      team_data.rels[:members].get.data.each do |member|
        user = User.where(github_username: member.login).first_or_create! do |u|
          u.name = $octoclient.user(member.login).name
        end
        team.members << user
      end

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
