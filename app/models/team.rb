class Team < ActiveRecord::Base
  has_many :memberships, class_name: 'TeamMembership'
  has_many :members, through: :memberships, source: :user

  validates_presence_of :organization, :name, :organization_id, :team_id, :issues_repo
  validates_uniqueness_of :name, scope: :organization

  def title
    "#{organization}/#{name}" if organization.present? && name.present?
  end

  def lookup_on_github! octoclient
    # FIXME: recover gracefully from these errors and attach as validation
    #   failures
    gh_org = octoclient.organization organization
    self.organization_id = gh_org.id

    gh_team = octoclient.organization_teams(organization).find do |t|
      t.name.downcase == name.downcase
    end
    self.team_id = gh_team.id

    gh_repo = octoclient.repo "#{organization}/#{issues_repo}"
  end

  def create_issue_tracking_webhook! octoclient
    octoclient.create_hook "#{organization}/#{issues_repo}", "web", {
      url: Rails.application.routes.url_helpers.receive_solutions_hook_url,
      secret: ENV.fetch('GITHUB_WEBHOOK_SECRET'),
      content_type: 'json'
    }, {
      events: ['issues'],
      active: true
    }
  end

  def sync! octoclient
    octoclient.team_members(team_id).each do |member|
      user = User.where(github_username: member.login).first_or_create! do |u|
        u.name = octoclient.user(member.login).name
      end
      members << user unless members.include? user
    end
  end

  def assign! octoclient, assignment
    members.each do |member|
      member.solutions.where(assignment: assignment).first_or_create! do |solution|

        issue = octoclient.open_issue issues_repo, assignment.title, assignment.as_issue,
          assignee: member.github_username, labels: 'homework'
        solution.number = issue.number
        solution.repo   = issues_repo
        solution.status = :assigned
      end
    end
  end
end
