class AddRepoIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :repo_id, :integer
  end
end
