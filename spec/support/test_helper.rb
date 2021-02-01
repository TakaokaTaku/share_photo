module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end

  def login_as(user)
    visit login_path
    fill_in 'メールアドレス',    with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
      remember_me: remember_me,
    } }
  end
end

RSpec.configure do |config|
  config.include TestHelper
end
