class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :agent_id
      t.integer :reputation
      t.integer :user_like
      t.integer :user_dislike
      t.timestamps null: false
    end
    add_index :records, :agent_id
    add_index :records, :reputation
    add_index :records, :user_like
    add_index :records, :user_dislike
  end
end
