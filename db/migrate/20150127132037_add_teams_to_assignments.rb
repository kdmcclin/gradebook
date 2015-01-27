class AddTeamsToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :team_id, :integer
  end
end
