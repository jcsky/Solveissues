class CreateLatestIssueVotes < ActiveRecord::Migration
  def change
    create_table :latest_issue_votes do |t|
      t.integer :user_id
      t.integer :issue_id

      t.timestamps null: false
    end

    add_index :latest_issue_votes, [:user_id, :issue_id]
  end
end
