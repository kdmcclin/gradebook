class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :url
      t.datetime :due_at

      t.timestamps null: false
    end
  end
end
