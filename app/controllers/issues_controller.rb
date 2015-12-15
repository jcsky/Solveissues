class IssuesController < ApplicationController

 before_action :set_issue, only: [:show, :edit, :update, :destroy]
 before_action :tag_cloud, only: [:index]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all
    @q = @issues.ransack(params[:q])

    if params[:tag]
        @issues = Tag.find_by_name(params[:tag]).issues.page(params[:page]).per(15)
    else
        @issues = @q.result(distinct: true).page(params[:page]).per(15)
    end

  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    authenticate_user!
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    authenticate_user!
    @issue = current_user.issues.new(issue_params)
    respond_to do |format|
      if @issue.save
        current_user.toggle_like(@issue)
        # @issue.votes.create(:user_id => current_user.id)
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:destroy_logo] == "1"
      @issue.logo = nil
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @issue = Issue.find(params[:id])
    current_user.toggle_like(@issue)

    respond_to do |format|
      format.html {
        redirect_to :back
      }
      format.js
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  # def destroy
  #   @issue.destroy
  #   respond_to do |format|
  #     format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:title, :description, :logo, :owner, :tag_list => [])
    end

    def tag_cloud
      # Tag cloud
      hash = []
      Tag.all.order('issue_count DESC').first(20).each do |x|
        weight = x.issue_count
        hash << { text: x.name, weight: weight, link: issues_path + '?tag=' + x.name  }
                                                    # issues_path(:tag => x.name)
      end
      @tag_cloud = hash
    end

end
