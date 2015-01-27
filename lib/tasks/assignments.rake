namespace :assignments do
  desc 'Check all active assignments'
  task :check => :environment do
    User.with_github_access.find_each do |user|
      team = user.active_team || next
      team.assignments.find_each do |assignment|
        assignment.check! user.octoclient
      end
    end
  end
end
