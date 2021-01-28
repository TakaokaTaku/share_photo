RSpec.describe "PostsInterfaces", type: :feature do
  let!(:user) { FactoryBot.create(:user, name: "foo", account_name: "1357") }
  let!(:other_user) { FactoryBot.create(:user, name: "hoge", account_name: "2468") }
  let!(:post) { FactoryBot.create(:post) }

  it "is user search interface" do
    login_as(user)

    click_on "検索"
    click_on "ユーザー"
    expect(page).not_to have_content user.name
    expect(page).not_to have_content other_user.name

    fill_in "name", with: user.name
    click_on "ユーザー検索"
    expect(page).to have_content user.name
    expect(page).not_to have_content other_user.name

    fill_in "name", with: other_user.account_name
    click_on "ユーザー検索"
    expect(page).to have_content other_user.name
    expect(page).not_to have_content user.name
  end

  it "is post search interface" do
    login_as(user)

    click_on "検索"
    click_on "投稿"
    expect(page).not_to have_selector ".garally"

    fill_in "content", with: post.content
    click_on "投稿検索"
    expect(page).to have_selector ".garally"
    all('.posts button')[0].click
    expect(page).to have_content post.content
  end
end
