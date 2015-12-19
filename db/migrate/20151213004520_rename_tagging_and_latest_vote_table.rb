class RenameTaggingAndLatestVoteTable < ActiveRecord::Migration
  def self.up
    rename_table :taggings, :issue_tags
    rename_table :latest_agent_votes, :agent_votes
    rename_table :latest_issue_votes, :issue_votes
  end

  def self.down
    rename_table :issue_tags, :taggings
    rename_table :agent_votes, :latest_agent_votes
    rename_table :issue_votes, :latest_issue_votes
  end
end
