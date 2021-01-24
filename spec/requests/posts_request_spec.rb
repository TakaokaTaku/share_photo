RSpec.describe "Posts", type: :request do
  describe "Posts#destroy" do
    let!(:post) { FactoryBot.create(:post) }
    let(:delete_request) { delete post_path(post) }

    context "when not logged in" do
      it "doesn't change Post's count" do
        expect { delete_request }.to change(Post, :count).by(0)
      end

      it "redirects to login_url" do
        expect(delete_request).to redirect_to login_url
      end
    end
  end
end
