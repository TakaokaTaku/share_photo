RSpec.describe "Posts", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "Get /posts" do
    describe "GET posts" do
      it "redirects login when not logged in" do
        get posts_path
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get posts_path
        expect(response).to have_http_status(:success)
        assert_select "title", "投稿検索 | SharePhoto"
      end
    end

    describe "GET /posts/:id" do
      let(:post) { FactoryBot.create(:post, content: "foobar") }

      it "redirects login when not logged in" do
        get post_path(post)
        expect(response).to redirect_to login_url
      end
    end

    describe "GET /posts/new" do
      it "redirects login when not logged in" do
        get new_post_path
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get new_post_path
        expect(response).to have_http_status(:success)
        assert_select "title", "写真投稿 | SharePhoto"
      end
    end
  end

  describe "delete /posts/:id" do
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
