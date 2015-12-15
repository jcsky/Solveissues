class VotesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_latest_agent_vote, only: [:like_user, :dislike_user, :unlike_user]
  before_action :find_agent, only: [:like_user, :dislike_user, :unlike_user]

  def create
    set_issue
    vote = @issue.find_vote_by_user(current_user)

    unless vote
      @vote = Vote.create(user: current_user, issue: @issue)
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.js {
        @issue.reload
        render :template => "votes/ajax"
      }
    end
  end

  def destroy
    set_issue
    @vote = current_user.votes.find(params[:id])
    @vote.destroy
    @vote = nil
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {
        @issue.reload
        render :template => "votes/ajax"
      }
    end
  end

  #Ajax

  def support_issue
    @issue = Issue.find(params[:id])
    if current_user.role == 1
      @issue.liked_by current_user, :vote_scope => "agent"
    else
      @issue.liked_by current_user
    end
  end

  def unsupport_issue
    @issue = Issue.find(params[:id])
    if current_user.role == 1
      @issue.unliked_by current_user, :vote_scope => "agent"
    else
      @issue.unliked_by current_user
    end
    render :support_issue
  end

  # user_voted_to_agent

  def like_user
    if @latest_agent_vote
      @latest_agent_vote.value = 1
      @latest_agent_vote.save
    else
      LatestAgentVote.create(:agent_id=>@agent.id, :user_id=>current_user.id, :value => 1)
    end
    redirect_to agent_list_path
  end

  def dislike_user
    if @latest_agent_vote
      @latest_agent_vote.value = -1
      @latest_agent_vote.save
    else
      LatestAgentVote.create(:agent_id=>@agent.id, :user_id=>current_user.id, :value => -1)
    end
    redirect_to agent_list_path
  end

  def unlike_user
    if @latest_agent_vote
      @latest_agent_vote.destroy
    end

    redirect_to agent_list_path
  end

private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def find_latest_agent_vote
    @agent = User.find(params[:id])
    @latest_agent_vote = LatestAgentVote.find_by(:agent_id=>@agent.id, :user_id=>current_user.id)
  end

  def find_agent
    @agent = User.find(params[:id])
  end

end
