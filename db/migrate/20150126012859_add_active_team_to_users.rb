class AddActiveTeamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_team_id, :integer
  end
end
