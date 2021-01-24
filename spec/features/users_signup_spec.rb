RSpec.feature "UsersSignups", type: :feature do
  it "is invalid with wrong infomation" do
    visit signup_path
    fill_in "Name", with: ""
    fill_in "Email", with: "user@invalid"
    fill_in "Password", with: "foo"
    fill_in "Confirmation", with: "bar"
    click_on "Create my account"
    expect(current_path).to eq users_path
    expect(page).to have_content 'Sign up'
    expect(page).to have_selector ".alert-danger"
  end

  it "is valid with correct infomation" do
    visit signup_path
    expect do
      fill_in "Name", with: "TestUser"
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "foobar"
      fill_in "Confirmation", with: "foobar"
      click_on "Create my account"
    end.to change(User, :count).by(1)
    expect(current_path).to eq root_path
    expect(page).to have_content "Please check your email to activate your account."
  end
end
