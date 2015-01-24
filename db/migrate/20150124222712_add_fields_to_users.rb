class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_username, :string
    add_column :users, :role, :string
  end
end
