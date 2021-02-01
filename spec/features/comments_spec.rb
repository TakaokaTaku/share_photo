RSpec.describe "Comments", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_users) { FactoryBot.create_list(:user, 10) }
  let(:post) { FactoryBot.create(:post) }

  before do
    login_as(user)
    post = user.posts.build(content: "foobar")
    post.image.attach(io: File.open('spec/fixtures/test_image.jpg'),
                filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save!

    other_users[0..9].each do |other_user|
      other_user.comments.create!(getter_id: post.id, content: "comment")
    end
  end

  it "is the correct number of comments in user's post" do
    visit user_path(user)
    within (find('.likes', visible: false)) do
      expect(page).to have_content "コメント\n#{user.posts.first.comments.count}"
    end
    all('.posts button')[0].click
    click_on "詳細ページへ"
    user.posts.first.comments.each do |u|
      expect(page).to have_content "comment"
    end
  end

  it "is deleated comments afetr posting a comment" do
    visit post_path(post.id)
    fill_in "comment_content", with: "comment"
    click_on "コメントする"
    expect(page).not_to have_link "コメントする"

    within (all('.users')[1]) do
      expect(page).to have_content "comment"
    end

    click_on "コメントを削除"
    expect(page).not_to have_link "コメントを削除"
    within '.users' do
      expect(page).not_to have_content "comment"
    end
  end
end
