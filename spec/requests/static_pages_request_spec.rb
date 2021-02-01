RSpec.describe "Staticpages", type: :request do
  describe "Get/home" do
    it "returns success request" do
      get root_path
      expect(response).to have_http_status(:success)
      assert_select "title", "SharePhoto"
    end
  end

  describe "Get/help" do
    it "returns success request" do
      get help_path
      expect(response).to have_http_status(:success)
      assert_select "title", "よくある質問 | SharePhoto"
    end
  end

  describe "Get/about" do
    it "returns success request" do
      get about_path
      expect(response).to have_http_status(:success)
      assert_select "title", "利用規約 | SharePhoto"
    end
  end

  describe "Get/contact" do
    it "returns success request" do
      get contact_path
      expect(response).to have_http_status(:success)
      assert_select "title", "お問合せ | SharePhoto"
    end
  end
end
