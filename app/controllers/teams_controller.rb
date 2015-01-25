class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find params[:id]

    @solutions = Solution.where(user: @team.members).
      map { |s| [[s.assignment_id, s.user_id], s] }.to_h
    @assignments = Assignment.find @solutions.keys.map(&:first).uniq.sort
  end

  def new
    # FIXME: breaks if `octoclient` returns a redirect
    @organizations = octoclient.organizations.reverse
  end

  def create
    org_data = octoclient.organizations.find { |o| o.login == params[:organization] }
    Organization.new(octoclient, org_data).load_teams!
    redirect_to teams_path
  end

  def activate
    current_user.update_attribute :active_team_id, params[:id]
    redirect_to :back
  end
end
