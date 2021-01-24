RSpec.describe "Staticpages", type: :request do
  describe "Get/home" do
    it "returns success request" do
      get root_path
      expect(response).to have_http_status(:success)
      assert_select "title", "Ruby on Rails Tutorial Sample App"
    end
  end

  describe "Get/help" do
    it "returns success request" do
      get help_path
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
    end
  end

  describe "Get/about" do
    it "returns success request" do
      get about_path
      expect(response).to have_http_status(:success)
      assert_select "title", "About | Ruby on Rails Tutorial Sample App"
    end
  end

  describe "Get/contact" do
    it "returns success request" do
      get contact_path
      expect(response).to have_http_status(:success)
      assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
    end
  end
end
