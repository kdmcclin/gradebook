class AddIssuesRepoToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :issues_repo, :string
  end
end
