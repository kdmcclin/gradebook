class Team < ActiveRecord::Base
  has_many :memberships, class_name: 'TeamMembership'
  has_many :members, through: :memberships, source: :user

  def self.active
    options = where active: true
    unless options.count == 1
      raise "Found #{options.count} active teams. Panicking."
    end
    options.first
  end

  def title
    "#{organization}/#{name}"
  end

  def repo
    # TODO: make this customizable?
    "#{organization}/course-notes"
  end

  def assign! octoclient, assignment
    members.each do |member|
      member.solutions.where(assignment: assignment).first_or_create! do |solution|

        issue = octoclient.open_issue repo, assignment.title, assignment.as_issue,
          assignee: member.github_username, labels: 'homework'
        solution.number = issue.number
        solution.repo   = repo
        solution.status = :assigned
      end
    end
  end
end
