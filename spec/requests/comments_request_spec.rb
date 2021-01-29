RSpec.describe "Comments", type: :request do
  describe "Comments#create" do
    let(:post_request) { post comments_path }

    context "when not logged in" do
      it "doesn't change Comment's count" do
        expect { post_request }.to change(Comment, :count).by(0)
      end

      it "redirects to login_url" do
        expect(post_request).to redirect_to login_url
      end
    end
  end

  describe "Comments#destroy" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:comment) { user.comments.build(getter_id: post.id,
                                          content: "foobar") }
    let(:delete_request) { delete favorite_path(post) }


    context "when not logged in" do
      it "doesn't change Comment's count" do
        expect { delete_request }.to change(Comment, :count).by(0)
      end

      it "redirects to login_url" do
        expect(delete_request).to redirect_to login_url
      end
    end
  end
end
