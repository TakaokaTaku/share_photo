RSpec.feature "UsersLogins", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it "is invalid with wrong infomation" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: ""
    click_button "Log in"
    expect(current_path).to eq login_path
    expect(page).to have_selector ".alert-danger"
    visit root_path
    expect(page).not_to have_selector ".alert-danger"
  end

  it "is valid with correct infomation" do
    visit login_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button "Log in"
    expect(current_path).to eq user_path(user)
    expect(page).not_to have_link 'Log in'
    expect(page).to have_link 'Log out', href: logout_path
    expect(page).to have_link 'Profile', href: user_path(user)
    click_on "Log out"
    expect(current_path).to eq root_path
    expect(page).to have_link 'Log in', href: login_path
    expect(page).not_to have_link 'Log out'
    expect(page).not_to have_link 'Profile'
  end
end
