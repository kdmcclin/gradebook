class Solution < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :user

  validates :repo, presence: true
  validates :number, presence: true, uniqueness: { scope: :repo }

  scope :incomplete, -> { where status: "assigned" }
  scope :complete, -> { where status: "closed" }

  def complete?
    status.to_s == "closed"
  end

  def html_url
    "https://github.com/#{repo}/issues/#{number}"
  end

  def remote octoclient
    @_remote ||= octoclient.issue repo, number
  end

  def check! octoclient
    if status != "closed" && remote(octoclient).state == "closed"
      update_attributes status: "closed", completed_at: remote(octoclient).closed_at
    end
  end
end
