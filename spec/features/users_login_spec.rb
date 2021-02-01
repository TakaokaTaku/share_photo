RSpec.feature "UsersLogins", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it "is invalid with wrong infomation" do
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: ""
    click_button "ログイン"
    expect(current_path).to eq login_path
    expect(page).to have_selector ".alert-danger"
    visit root_path
    expect(page).not_to have_selector ".alert-danger"
  end

  it "is valid with correct infomation" do
    visit login_path
    fill_in 'メールアドレス',    with: user.email
    fill_in 'パスワード', with: user.password
    click_button "ログイン"
    expect(current_path).to eq user_path(user)
    expect(page).not_to have_link 'ログイン'
    expect(page).to have_link 'ログアウト', href: logout_path
    click_on "ログアウト"
    expect(current_path).to eq root_path
    expect(page).to have_link 'ログイン', href: login_path
    expect(page).not_to have_link 'ログアウト'
  end
end
