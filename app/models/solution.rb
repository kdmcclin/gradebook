class Solution < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :user

  validates :repo, presence: true
  validates :number, presence: true, uniqueness: { scope: :repo }

  scope :complete, -> { where status: "closed" }

  def remote
    @_remote ||= $octoclient.issue repo, number
  end

  def check!
    if status != "closed" && remote.state == "closed"
      update_attributes status: "closed", completed_at: remote.closed_at
    end
  end

  def html_url
    remote.html_url
  end
end
