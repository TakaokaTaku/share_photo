module UsersHelper
  DEFAULT_ICON_SIZE = 50

  def icon(user = nil, size = DEFAULT_ICON_SIZE)
    if user && user.picture.attached?
      image_tag( user.picture, size: "#{size}x#{size}" )
    else
      image_tag( "default_icon.svg", size: "#{size}x#{size}" )
    end
  end
end
