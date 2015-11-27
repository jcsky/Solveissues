class Admin::UsersController < ApplicationController

  layout "admin"

  def index
    @users = User.all
    @agents = User.agents.all
    @issues = Issue.all

    @total_agents_likes = HistoricalAgentVote.all.to_a.sum(&:likes_count)
    @total_agents_dislikes = HistoricalAgentVote.all.to_a.sum(&:dislikes_count)
    @total_issues_likes = HistoricalIssueVote.all.to_a.sum(&:likes_count)
    
  end
end
