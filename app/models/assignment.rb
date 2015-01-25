class Assignment < ActiveRecord::Base
  has_many :solutions, dependent: :destroy

  validates :path, presence: true, uniqueness: true
  validates :title, presence: true

  before_validation do
    unless self.title.present?
      self.title = markdown.split("\n").grep(/^# /).first[2..-1].strip
    end
  end

  def self.raw_url path
    "https://raw.githubusercontent.com/#{path}"
  end

  def raw_url
    self.class.raw_url path
  end

  def html_url
    "https://github.com/#{path}"
  end

  def markdown
    @_markdown ||= HTTParty.get raw_url
  end

  def as_issue
    "_Due on #{ApplicationHelper.format_datetime due_at}_\n#{markdown}"
  end
end
