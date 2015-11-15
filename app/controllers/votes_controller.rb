class VotesController < ApplicationController

  before_action :authenticate_user!

  # Pages
  def agent_list
    @total_agents = User.where(role: "1").includes(:votes)
    @agents = @total_agents.page(params[:page]).per(10)
    @user_issues = current_user.find_voted_items(:votable_type => 'Issue')

    # current_user ? @user_issues = current_user.vote_issues : User.new.vote_issues

    # way1
    # Vote.where( :scope => "agent" ).group_by
  end

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

  def like_user
    @agent = User.find(params[:id])
    @agent.liked_by current_user
  end

  def dislike_user
    @agent = User.find(params[:id])
    @agent.disliked_by current_user
    render :like_user
  end

  def unlike_user
    @agent = User.find(params[:id])
    @agent.unliked_by current_user
  end

private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

end
