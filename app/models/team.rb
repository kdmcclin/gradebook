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

  def assign! assignment
    members.each do |member|
      member.solutions.where(assignment: assignment).first_or_create! do |solution|

        issue = $octoclient.open_issue repo, assignment.title, assignment.as_issue,
          assignee: member.github_username, labels: 'homework'

        solution.repo   = repo
        solution.number = issue.number
        solution.status = :assigned
      end
    end
  end

  def report path
    solutions = Solution.where(user: members).map { |s| [[s.assignment_id, s.user_id], s] }.to_h
    assignments = Assignment.find solutions.keys.map(&:first).uniq.sort

    CSV.open path, "w" do |csv|
      row = ['', '']
      assignments.each { |a| row += [a.title, ''] }
      csv << row

      row = ['User', 'Github']
      assignments.each { |a| row += [a.html_url, a.due_at] }
      csv << row

      members.each do |member|
        row = [member.name, member.github_username]
        assignments.each do |a|
          solution = solutions[ [a.id, member.id] ]
          row += if solution
            [solution.html_url, solution.completed_at]
          else
            ['', '']
          end
        end
        csv << row
      end
    end
  end
end
