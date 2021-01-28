RSpec.describe Favorite, type: :model do
  describe "validation" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:favorite) { user.active_favorites.build(liked_id: post.id) }

    it "is valid with test data" do
      expect(favorite).to be_valid
    end

    it "is invalid without liker_id" do
      favorite.liker_id = nil
      expect(favorite).to be_invalid
    end

    it "is invalid without liked_id" do
      favorite.liked_id = nil
      expect(favorite).to be_invalid
    end
  end
end
