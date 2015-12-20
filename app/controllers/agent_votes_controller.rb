class AgentVotesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_agent
  before_action :set_agent_vote


  def like_user
    if @agent_vote
      @agent_vote.value = 1
      @agent_vote.save
    else
      AgentVote.create(:agent_id=>@agent.id, :user_id=>current_user.id, :value => 1)
    end
    redirect_to agent_list_path(:page => params[:page])
  end

  def dislike_user
    if @agent_vote
      @agent_vote.value = -1
      @agent_vote.save
    else
      AgentVote.create(:agent_id=>@agent.id, :user_id=>current_user.id, :value => -1)
    end

    redirect_to agent_list_path(:page => params[:page])
  end

  def unlike_user
    if @agent_vote
      @agent_vote.destroy
    end

    redirect_to agent_list_path(:page => params[:page])
  end

private

  def set_agent_vote
    @agent_vote = AgentVote.find_by(:agent_id=>@agent.id, :user_id=>current_user.id)
  end

  def set_agent
    @agent = User.find(params[:id])
  end

end
