class AddBodyToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :body, :text
  end
end
