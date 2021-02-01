RSpec.describe "Notices", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "Get /notice" do
    it "redirects login when not logged in" do
      get notices_path
      expect(response).to redirect_to login_url
    end

    it "returns success request" do
      log_in_as(user)
      get notices_path
      expect(response).to have_http_status(:success)
      assert_select "title", "通知 | SharePhoto"
      expect(response.body).to include '通知はありません'
    end
  end
end
