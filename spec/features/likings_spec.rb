RSpec.describe "Likings", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_users) { FactoryBot.create_list(:user, 10) }
  let(:posts) { FactoryBot.create_list(:post, 6) }

  before do
    login_as(user)
    post = user.posts.build(content: "foobar")
    post.image.attach(io: File.open('spec/fixtures/test_image.jpg'),
                filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save!

    posts[0..4].each do |post|
      user.active_favorites.create!(liked_id: post.id)
    end

    other_users[0..9].each do |other_user|
      other_user.active_favorites.create!(liked_id: post.id)
    end
  end

  it "is the correct number of liking" do
    click_on "liking"
    expect(user.liking.count).to eq 5
    expect(page).to have_content "お気に入り(#{user.liking.count})"
    expect(all('.garally').size).to eq(5)
  end

  it "is the correct number of likers in user's post" do
    click_on "posts"
    expect(user.posts.first.likers.count).to eq 10
    within (find('.likes', visible: false)) do
      expect(page).to have_content "お気に入り: #{user.posts.first.likers.count}"
    end
    all('.posts button')[0].click
    click_on "詳細ページへ"
    click_on "お気に入り"
    user.posts.first.likers.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
  end

  it "When user clicks on Unlike, the number of liking increases by -1" do
    visit post_path(posts.first.id)
    expect do
      click_on "お気に入り解除"
      expect(page).not_to have_link "お気に入り解除"
      visit current_path
    end.to change(user.liking, :count).by(-1)
  end

  it "When user clicks on Like, the number of liking increases by 1" do
    visit post_path(posts.last.id)
    expect do
      click_on "お気に入り"
      expect(page).not_to have_link "お気に入り"
      visit current_path
    end.to change(user.liking, :count).by(1)
  end
end
