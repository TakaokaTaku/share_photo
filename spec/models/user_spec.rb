RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  it "is valid" do
    expect(user).to be_valid
  end

  it "is invalid with no name" do
    user.name = "     "
    expect(user).not_to be_valid
  end

  it "is invalid with no email" do
    user.email = "    "
    expect(user).not_to be_valid
  end

  it "is invalid with the long name" do
    user.name = "a" * 51
    expect(user).not_to be_valid
  end

  it "is invalid with the long email" do
    user.email = "a" * 244 + "example.com"
    expect(user).not_to be_valid
  end

  it 'is valid with the correct email format' do
    valid_addresses = %w(
      user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn
    )
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it 'is invalid with the wrong email format' do
    invalid_addresses = %w(
      user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com
    )
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid
    end
  end

  it "is invalid with registered email" do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it "is invalid with no password" do
    user.password = " " * 6
    expect(user).not_to be_valid
  end

  it "is invalid with the short password" do
    user.password = user.password_confirmation = "a" * 5
    expect(user).not_to be_valid
  end

  it "returns false for a user with nil digest" do
    expect(user.authenticated?(:remember, '')).to be_falsy
  end

  it "is destroied with posts" do
    user.save
    post = user.posts.build(content: 'foobar')
    post.image.attach(io: File.open('spec/fixtures/test_image.jpg'),
                filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save
    expect do
      user.destroy
    end.to change(Post, :count).by(-1)
  end

  it "is followed and unfollowed" do
    user.save
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
    expect(other_user.followers.include?(user)).to be_truthy

    user.unfollow(other_user)
    expect(user.following?(other_user)).to be_falsy
  end

  describe "def feed" do
    let(:user) { FactoryBot.create(:user, :with_posts) }
    let(:other_user) { FactoryBot.create(:user, :with_posts) }

    context "when user is following other_user" do
      before { user.active_relationships.create!(followed_id: other_user.id) }

      it "contains other user's microposts within the user's Post" do
        other_user.posts.each do |post_following|
          expect(user.feed.include?(post_following)).to be_truthy
        end
      end

      it "contains the user's own posts in the user's Post" do
        user.posts.each do |post_self|
          expect(user.feed.include?(post_self)).to be_truthy
        end
      end
    end

    context "when user is not following other_user" do
      it "doesn't contain other user's posts within the user's Post" do
        other_user.posts.each do |post_unfollowed|
          expect(user.feed.include?(post_unfollowed)).to be_falsy
        end
      end
    end
  end
end
