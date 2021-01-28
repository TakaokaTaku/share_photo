RSpec.describe "Favorites", type: :request do
  describe "Favorites#create" do
    let(:post_request) { post favorites_path }

    context "when not logged in" do
      it "doesn't change Favorite's count" do
        expect { post_request }.to change(Favorite, :count).by(0)
      end

      it "redirects to login_url" do
        expect(post_request).to redirect_to login_url
      end
    end
  end

  describe "Favorites#destroy" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:delete_request) { delete favorite_path(post) }

    before { user.liking << post }

    context "when not logged in" do
      it "doesn't change Favorite's count" do
        expect { delete_request }.to change(Favorite, :count).by(0)
      end

      it "redirects to login_url" do
        expect(delete_request).to redirect_to login_url
      end
    end
  end
end
