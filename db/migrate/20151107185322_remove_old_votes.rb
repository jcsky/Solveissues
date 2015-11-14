class RemoveOldVotes < ActiveRecord::Migration
  def change
    drop_table :old_votes
    drop_table :likes
    change_table :votes do |t|
      t.remove :issue_id
      t.remove :user_id
    end
  end
end
