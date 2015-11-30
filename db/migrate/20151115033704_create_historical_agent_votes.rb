class CreateHistoricalAgentVotes < ActiveRecord::Migration
  def change
    create_table :historical_agent_votes do |t|
      t.integer :agent_id
      t.integer :likes_count
      t.integer :dislikes_count
      t.text :liked_users
      t.text :disliked_users
      t.date :vote_date

      t.timestamps null: false
    end

    add_index :historical_agent_votes, :agent_id
  end

end
