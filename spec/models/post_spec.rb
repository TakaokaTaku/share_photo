RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }
  let!(:day_before_yesterday) { FactoryBot.create(:post, :day_before_yesterday) }
  let!(:now) { FactoryBot.create(:post, :now) }
  let!(:yesterday) { FactoryBot.create(:post, :yesterday) }

  it "is valid" do
    expect(post).to be_valid
  end

  it "is invalid with no user_id" do
    post.user_id = nil
    expect(post).to be_invalid
  end

  it "is invalid with no content" do
    post.content = " "
    expect(post).to be_invalid
  end

  it "is invalid with no image" do
    post.image = nil
    expect(post).to be_invalid
  end

  it "is invalid with the long content" do
    post.content = "a" * 141
    expect(post).to be_invalid
  end

  it "is sorted by latest" do
    expect(Post.first).to eq now
  end

  describe "notice" do
    let(:user) { FactoryBot.create(:user) }

    it "is created notice_like" do
      notice = post.create_notice_like(user)
      expect(notice).to be_truthy
      expect do
        post.create_notice_like(user)
      end.to change(Notice, :count).by(0)
    end

    it "is created notice_comment" do
      comment = user.comments.create(getter_id: post.id)
      notice = post.create_notice_comment(user,comment.id)
      expect(notice).to be_truthy
      expect do
        post.create_notice_comment(user,comment.id)
      end.to change(Notice, :count).by(1)
    end
  end
end
