class AddActiveToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :active, :boolean
  end
end
