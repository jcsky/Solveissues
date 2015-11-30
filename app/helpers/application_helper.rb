module ApplicationHelper

  def icon(name)
    "<span class=\"glyphicon glyphicon-#{name}\"><span>".html_safe
  end

  def icon_flipy(name)
    "<span class=\"glyphicon glyphicon-#{name} flipy\"><span>".html_safe
  end

  def login?
    current_user != nil
  end

end
