class Assignment < ActiveRecord::Base
  has_many :solutions

  validates :path, presence: true, uniqueness: true

  def self.raw_url path
    "https://raw.githubusercontent.com/#{path}"
  end

  def markdown
    @_markdown ||= HTTParty.get Assignment.raw_url path
  end

  def title
    markdown.split("\n").grep(/^# /).first[2..-1].strip
  end
end
