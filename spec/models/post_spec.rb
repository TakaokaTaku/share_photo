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
end
