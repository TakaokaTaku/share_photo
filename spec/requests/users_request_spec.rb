RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /users" do
    describe "GET users" do
      it "redirects login when not logged in" do
        get users_path
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get users_path
        expect(response).to have_http_status(:success)
        assert_select "title", "ユーザー検索 | Ruby on Rails Tutorial Sample App"
      end

      describe "searching in users" do
        let!(:user) { FactoryBot.create(:user, name: "foo", account_name: "1357") }
        let!(:other_user) { FactoryBot.create(:user, name: "hoge", account_name: "2468") }

        before { log_in_as(user) }

        context "searching [f]" do
          it "should display foo" do
            get users_path, params: { user: {
              name: "f",
            } }
            expect(response.body).to include 'foo'
          end
        end

        context "searching [35]" do
          it "should display hoge" do
            get users_path, params: { user: {
              name: "35",
            } }
            expect(response.body).to include 'foo'
          end
        end
      end
    end

    describe "GET /users/:id" do
      it "redirects login when not logged in" do
        get user_path(user)
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get user_path(user)
        expect(response).to have_http_status(:success)
        assert_select "title", "#{user.name} | Ruby on Rails Tutorial Sample App"
      end
    end

    describe "GET /users/new" do
      it "returns success request" do
        get signup_path
        expect(response).to have_http_status(:success)
        assert_select "title", "新規登録 | Ruby on Rails Tutorial Sample App"
      end
    end

    describe "GET /users/:id/edit" do
      it "redirects login when not logged in" do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get edit_user_path(user)
        expect(response).to have_http_status(:success)
        assert_select "title", "プロフィール編集 | Ruby on Rails Tutorial Sample App"
      end
    end

    describe "GET /users/:id/edit/password" do
      it "redirects login when not logged in" do
        get edit_password_user_path(user)
        expect(response).to redirect_to login_url
      end

      it "returns success request" do
        log_in_as(user)
        get edit_password_user_path(user)
        expect(response).to have_http_status(:success)
        assert_select "title", "パスワード変更 | Ruby on Rails Tutorial Sample App"
      end
    end
  end

  describe "POST /users" do
    let(:user) { FactoryBot.attributes_for(:user) }

    it "adds new user with correct signup information and sends an activation email" do
      aggregate_failures do
        expect do
          post users_path, params: { user: user }
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(response).to redirect_to root_url
        expect(is_logged_in?).to be_falsy
      end
    end
  end

  describe "PATCH /users/:id" do
    before { log_in_as(user) }

    it 'fails edit with wrong information' do
      patch user_path(user), params: { user: {
        name: " ",
        account_name: " ",
        email: "foo@invalid",
        tel: " ",
      } }
      expect(response).to have_http_status(200)
    end

    it 'succeeds edit with correct information' do
      patch user_path(user), params: { user: {
        name: "Foo Bar",
        account_name: "foo-bar-user",
        email: "foo@bar.com",
        tel: "111-1111-1111",
        website: "https://foobar.com",
        gender: 1,
        introduction: "hello world!"
      } }
      expect(response).to redirect_to user_path(user)
    end
  end

  describe "PATCH /users/:id/password" do
    before { log_in_as(user) }

    context 'present_password is wrong' do
      it 'fails editing password' do
        patch edit_password_user_path(user), params: { user: {
          present_password:  "hogehoge",
          password: "hogehoge",
          password_confirmation: "hogehoge",
        } }
        expect(response).to have_http_status(200)
      end
    end
    context 'password_confirmation is wrong' do
      it 'fails editing password' do
        patch edit_password_user_path(user), params: { user: {
          present_password:  "foobar",
          password: "foo",
          password_confirmation: "bar",
        } }
        expect(response).to have_http_status(200)
      end
      context 'correct password infomation' do
        it 'succeeds editing password' do
          patch edit_password_user_path(user), params: { user: {
            present_password:  "foobar",
            password: "hogehoge",
            password_confirmation: "hogehoge",
          } }
          expect(response).to redirect_to user_path(user)
        end
      end
    end
  end

  describe "before_action: :logged_in_user" do
    it 'redirects edit when not logged in' do
      get edit_user_path(user)
      expect(response).to redirect_to login_path
    end

    it 'redirects update when not logged in' do
      patch user_path(user), params: { user: {
        name: user.name,
        email: user.email,
      } }
      expect(response).to redirect_to login_path
    end
    it 'redirects delete when not logged in' do
      delete user_path(user)
      expect(response).to redirect_to login_url
    end

    it 'redirects following when not logged in' do
      get following_user_path(user)
      expect(response).to redirect_to login_url
    end

    it 'redirects followers when not logged in' do
      get followers_user_path(user)
      expect(response).to redirect_to login_url
    end
  end

  describe "before_action: :correct_user" do
    let(:other_user) { FactoryBot.create(:user) }

    before { log_in_as(other_user) }

    it 'redirects edit when logged in as wrong user' do
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end

    it 'redirects update when logged in as wrong user' do
      patch user_path(user), params: { user: {
        name: user.name,
        eemail: user.email,
      } }
      expect(response).to redirect_to root_path
    end
  end

  describe "delete /users/:id" do
    let!(:other_user) { FactoryBot.create(:user) }

    it 'fails when not correct user' do
      log_in_as(user)
      aggregate_failures do
        expect do
          delete user_path(other_user)
        end.to change(User, :count).by(0)
        expect(response).to redirect_to root_url
      end
    end

    it 'succeds when correct user' do
      log_in_as(user)
      aggregate_failures do
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
        expect(response).to redirect_to root_url
      end
    end
  end
end
