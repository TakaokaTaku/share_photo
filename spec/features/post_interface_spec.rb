RSpec.describe "MicropostsInterfaces", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  before do
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      user.posts.create!(content: content)
    end
  end

  it "is post interface" do
    login_as(user)
    click_on "Home"

    click_on "Post"
    expect(page).to have_selector ".alert-danger"

    click_on "2"
    expect(URI.parse(current_url).query).to eq "page=2"

    valid_content = "This post really ties the room together"
    fill_in "post_content", with: valid_content
    attach_file 'post[image]', "#{Rails.root}/spec/fixtures/kitten.jpg"
    expect do
      click_on "Post"
      expect(current_path).to eq root_path
      expect(page).to have_selector ".alert-success"
      expect(page).to have_selector "img[src$='kitten.jpg']"
    end.to change(Post, :count).by(1)

    expect do
      page.accept_confirm do
        all('ol li')[0].click_on "delete"
      end
      expect(current_path).to eq root_path
      expect(page).to have_selector ".alert-success"
    end.to change(Post, :count).by(-1)

    # 違うユーザのプロフィールにアクセス(削除リンクがないことを確認)
    visit user_path(post.user)
    expect(page).not_to have_link "delete"
  end
end
