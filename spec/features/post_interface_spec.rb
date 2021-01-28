RSpec.describe "PostsInterfaces", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  before do
    10.times do
      content = Faker::Lorem.sentence(word_count: 5)
      post = user.posts.build(content: content)
      post.image.attach(io: File.open('spec/fixtures/test_image.jpg'),
                  filename: 'test_image.jpg', content_type: 'image/jpeg')
      post.save!
    end
  end

  it "is post interface" do
    login_as(user)

    click_on "Post"
    click_on "投稿"
    expect(page).to have_selector ".alert-danger"

    valid_content = "This post is valid"
    fill_in "post_content", with: valid_content
    attach_file 'post[image]', "#{Rails.root}/spec/fixtures/kitten.jpg"

    expect do
      click_on "投稿"
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector ".alert-success"
      expect(page).to have_selector "img[src$='kitten.jpg']"
    end.to change(Post, :count).by(1)

    expect do
      all('.posts button')[0].click
      all('.modal-footer')[1].click_on "詳細ページへ"
      click_on "削除"
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector ".alert-success"
    end.to change(Post, :count).by(-1)

    click_on "2"
    expect(URI.parse(current_url).query).to eq "page=2"

    visit user_path(post.user)
    all('.posts button')[0].click
    expect(page).not_to have_button "削除"
  end
end
