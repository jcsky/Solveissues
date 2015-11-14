class ChangeVotesTableName < ActiveRecord::Migration
  def change
    rename_table :votes, :old_votes
  end
end
