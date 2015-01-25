class Organization
  def self.all
    $octoclient.user.rels[:organizations].get.data.map { |o| new o }.reverse
  end

  def initialize org_data
    @data = org_data
  end

  def name
    @data.login
  end

  def id
    @data.id
  end

  def teams
    Team.where organization: name, organization_id: id
  end

  def load_teams!
    $octoclient.organization_teams(name).map do |team_data|
      team = teams.where(name: team_data.name, team_id: team_data.id).first_or_create!

      team_data.rels[:members].get.data.each do |member|
        user = User.where(github_username: member.login).first_or_create! do |u|
          u.name = $octoclient.user(member.login).name
        end
        team.members << user
      end
    end
  end
end
