class CreateLatestAgentVotes < ActiveRecord::Migration
  def change
    create_table :latest_agent_votes do |t|
      t.integer :value
      t.integer :user_id
      t.integer :agent_id

      t.timestamps null: false
    end

     add_index :latest_agent_votes, [:user_id, :agent_id]
  end

end
