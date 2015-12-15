class ApiV1::IssuesController < ApiController

  def index
    @issues = Issue.all
  end

  def show
    @issue = Issue.find(params[:id])
    @celebrates = @issue.vote_users.where(role: 1)
  end

  def create
    @issue = Issue.new( title: params[:title],
                        description: params[:discription],
                        owner: params[:authentication_token]
      )
    user = User.find_by_id(params[:authentication_token])

    if @issue.save
      @issue.votes.create(:user_id => params[:authentication_token])
      render :json => { :status => 200,
                        :message => "Issue create ok",
                        :auth_token => user.authentication_token,
                        :issue => @issue
                      }

    else
      render :json => { :message => "Issue create fault" }, :status => 401
    end
  end

end
