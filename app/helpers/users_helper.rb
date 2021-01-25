module UsersHelper

  def icon(user, size)
    if user.picture.attached?
      image_tag( user.picture, size: "#{size}x#{size}" )
    else
      image_tag( "default_icon.svg", size: "#{size}x#{size}" )
    end
  end

  # 渡されたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
