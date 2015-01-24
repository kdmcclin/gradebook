class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :assignment_id
      t.integer :user_id
      t.string :issue_id
      t.string :status
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
