RSpec.describe "NoticesInterfaces", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    post = other_user.posts.build(content: "foobar")
    post.image.attach(io: File.open('spec/fixtures/test_image.jpg'),
                filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save!
    login_as(user)
  end

  it "is notice_follow interface" do
    visit user_path(other_user)
    click_on "フォロー"

    login_as(other_user)
    expect(page).to have_content "通知(1)"
    click_on "通知"
    expect(page).to have_content "#{user.name} さんが あなたをフォローしました"
    click_on user.name
    expect(current_path).to eq user_path(user.id)
  end

  it "is notice_like interface" do
    visit post_path(other_user.posts.first.id)
    click_on "お気に入り"

    login_as(other_user)
    expect(page).to have_content "通知(1)"
    click_on "通知"
    expect(page).to have_content "#{user.name} さんが あなたの投稿 にいいねしました"
    click_on user.name
    expect(current_path).to eq user_path(user.id)
    click_on "通知"
    click_on "あなたの投稿"
    expect(current_path).to eq post_path(other_user.posts.first.id)
  end

  it "is notice_comment interface" do
    visit post_path(other_user.posts.first.id)
    fill_in "comment_content", with: "valid_comment"
    click_on "コメントする"

    login_as(other_user)
    expect(page).to have_content "通知(1)"
    click_on "通知"
    expect(page).to have_content "#{user.name} さんが あなたの投稿 にコメントしました"
    expect(page).to have_content other_user.posts.first.comments.first.content
    click_on user.name
    expect(current_path).to eq user_path(user.id)
    click_on "通知"
    click_on "あなたの投稿"
    expect(current_path).to eq post_path(other_user.posts.first.id)
  end
end
