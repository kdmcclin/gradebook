class AddGistToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :gist_id, :string
    remove_column :assignments, :path, :string
  end
end
