module UsersHelper
  def show_avatar(user)
    if user.avatar.attached?
      image_tag(url_for(user.avatar), height: 30, class: 'd-inline-block align-top')
    else
      "<i class='material-icons'>person</i>".html_safe
    end
  end
end
