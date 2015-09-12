class UsersController < ApplicationController

  before_action :set_user, :only => [:show, :edit, :update]

  def show
    @agent = User.where(role: "1")
    @user_issues = []
    @user.vote_issues.each do |u_issue|
      @user_issues << u_issue.id
    end
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





private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :description, :country)
  end


end