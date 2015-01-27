class AddCheckedAtToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :checked_at, :datetime
  end
end
