class Organization
  def initialize client, data
    @client, @data = client, data
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
    @client.organization_teams(name).map do |team_data|
      team = teams.where(name: team_data.name, team_id: team_data.id).first_or_create!

      team_data.rels[:members].get.data.each do |member|
        user = User.where(github_username: member.login).first_or_create! do |u|
          u.name = @client.user(member.login).name
        end
        team.members << user unless team.members.include? user
      end
    end
  end
end
