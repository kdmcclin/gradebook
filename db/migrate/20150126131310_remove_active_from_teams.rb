class RemoveActiveFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :active, :boolean
  end
end
