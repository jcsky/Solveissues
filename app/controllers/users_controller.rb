class UsersController < ApplicationController
  before_action :set_user, :only => [:show, :edit, :update]
  before_action :get_history_likes, :only => :show

  def show
    @user_issues = @user.like_issues
    # 有共同議題的user_ids
    @touched_user_ids = LatestIssueVote.where(:issue_id => @user_issues.map(&:id)).pluck(:user_id).uniq
    # 有共同議題的agents
    @touched_agents = User.where(:role => 1, :id => @touched_user_ids)
  end

  def edit
  end

  def update
    if @user.update!(user_params)
      flash[:success] = "更新成功"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  # Pages
  def agent_list
    User.record_count
    @total_agents = User.agents
    @agents = @total_agents.page(params[:page]).per(10)

    if params[:sort] 
      sort = "records.#{params[:sort]} DESC"
      @agents = @total_agents.includes(:record).order(sort).page(params[:page]).per(10)
    end
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :description, :country, :register_homecity, :birthday, :gender, :information_attributes => [:party, :job, :party_job, :experience, :election_position, :experience, :election_area])
  end

  def get_history_likes
    @likes_history = HistoricalAgentVote.where(:agent_id => @user)
    @likes = []
    @date = []

    @likes_history.each do |x|
      @likes.push((x.likes_count - x.dislikes_count).to_i)
      @date.push(x.vote_date.to_s)
    end
  end


end
