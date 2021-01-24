RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
    } }
  end

  describe "Get #new" do
    it "returns success request" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "Post #create (login)" do
    it "has sessions" do
      expect(response).to redirect_to user_path(user)
      expect(is_logged_in?).to be_truthy
    end

    it "remembers the cookie when user checks the Remember Me box" do
      log_in_as(user)
      expect(cookies[:remember_token]).not_to eq nil
    end

    it "does not remembers the cookie when user does not checks the Remember Me box" do
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end

  describe "Delete #destroy (logout)" do
    it 'does not have sessions' do
      delete logout_path
      expect(response).to redirect_to root_path
      expect(is_logged_in?).to be_falsy
    end

    it "does not have errors with second delete" do
      delete logout_path
      delete logout_path
      expect(response).to redirect_to root_path
      expect(is_logged_in?).to be_falsy
    end
  end

  describe "friendly forwarding" do
    it 'succeeds' do
      delete logout_path
      get edit_user_path(user)
      log_in_as(user)
      expect(response).to redirect_to edit_user_url(user)
    end
  end
end
