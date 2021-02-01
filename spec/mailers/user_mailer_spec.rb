RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq "SharePhotoのアカウント有効化"
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "password_reset" do
    before { user.reset_token = User.new_token }

    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("SharePhotoのパスワードリセット")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end
