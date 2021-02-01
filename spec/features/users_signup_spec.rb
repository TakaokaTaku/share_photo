RSpec.feature "UsersSignups", type: :feature do
  it "is invalid with wrong infomation" do
    visit signup_path
    fill_in "名前", with: ""
    fill_in "アカウント名", with: ""
    fill_in "メールアドレス", with: "user@invalid"
    fill_in "電話番号", with: ""
    fill_in "パスワード", with: "foo"
    fill_in "パスワード（再入力）", with: "bar"
    click_on "アカウント作成"
    expect(current_path).to eq users_path
    expect(page).to have_content '新規登録'
    expect(page).to have_selector ".alert-danger"
  end

  it "is valid with correct infomation" do
    visit signup_path
    expect do
      fill_in "名前", with: "TestUser"
      fill_in "アカウント名", with: "testuser"
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "電話番号", with: "000-0000-0000"
      fill_in "パスワード", with: "foobar"
      fill_in "パスワード（再入力）", with: "foobar"
      click_on "アカウント作成"
    end.to change(User, :count).by(1)
    expect(current_path).to eq root_path
    expect(page).to have_content "メールより、アカウントを有効にしてください"
  end
end
