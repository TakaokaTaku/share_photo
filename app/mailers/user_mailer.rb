class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "SharePhotoのアカウント有効化"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "SharePhotoのパスワードリセット"
  end
end
