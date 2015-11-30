module IssuesHelper
  def has_vote?(user,issue)
    if user.votes.where(:issue_id => issue.id)
      '我支持'
    end
  end

  def render_issue_like_botton(issue)
    if issue.like_by_user?(current_user)
      link_to like_issue_path(issue), method: :post, class: "btn btn-primary", id: "like-#{issue.id}", remote: true do
        content_tag :span, '', class: "glyphicon glyphicon-thumbs-up"
      end
    else
      link_to like_issue_path(issue), method: :post, class: "btn btn-default", id: "like-#{issue.id}", remote: true do
        content_tag :span, '', class: "glyphicon glyphicon-thumbs-up"
      end
    end
  end

  def render_issue_name_link(issue)
    link_to issue.title, issue
  end

end
