class CreateHistoricalIssueVotes < ActiveRecord::Migration
  def change
    create_table :historical_issue_votes do |t|
      t.integer :issue_id
      t.integer :likes_count
      t.text :liked_users
      t.date :vote_date

      t.timestamps null: false
    end

    add_index :historical_issue_votes, :issue_id
  end
end
