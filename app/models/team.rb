class Team < ActiveRecord::Base
  has_many :memberships, class_name: 'TeamMembership'
  has_many :members, through: :memberships, source: :user

  def title
    "#{organization}/#{name}"
  end

  def base_repo
    # TODO: make this customizable
    "#{organization}/course-notes"
  end

  def assign! assignment
    repo        = base_repo
    title       = assignment.title
    description = "_Due on #{assignment.due_at.strftime '%b %d @ %H:%M'}_\n#{assignment.markdown}"
    members.each do |member|
      member.solutions.where(assignment: assignment).first_or_create! do |solution|

        issue = $octoclient.open_issue repo, title, description,
          assignee: member.github_username, label: 'Homework'

        solution.repo   = repo
        solution.number = issue.number
        solution.status = :assigned
      end
    end
  end
end
