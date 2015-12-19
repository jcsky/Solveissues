class MainController < ApplicationController

  layout "main"

  def index
    @issues = Issue.all
    @hot_issue = @issues.first
    @q = @issues.ransack(params[:q])
  end

end
