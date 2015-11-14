class CreateAgentHistories < ActiveRecord::Migration
  def change
    create_table :agent_histories do |t|
      t.integer :user_id, null: false
      t.date :date, null: false
      t.integer :likes, null: false
      t.timestamps null: false
    end
    add_index :agent_histories, :user_id
  end
end
