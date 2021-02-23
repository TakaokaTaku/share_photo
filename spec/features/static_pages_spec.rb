RSpec.feature "StaticPages", type: :feature do
  it "has correct links" do
    visit root_path
    expect(page).to have_link "SharePhotoとは？",   href: about_path
    expect(page).to have_link "新規登録",           href: signup_path
    expect(page).to have_link "ログイン",           href: login_path
    expect(page).to have_link "よくある質問",        href: help_path
    expect(page).to have_link "利用規約",           href: terms_path
    expect(page).to have_link "お問合せ",           href: contact_path
  end
end
