class MainController < ApplicationController

  layout "main"

  def index
    @issues = Issue.all
    @q = @issues.ransack(params[:q])
  end

end
